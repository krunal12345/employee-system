import { Component, effect, inject, input, output, TemplateRef, viewChild } from '@angular/core';
import { AbstractControl, FormsModule, NonNullableFormBuilder, ReactiveFormsModule, ValidationErrors, ValidatorFn, Validators } from '@angular/forms';

import { takeUntil } from 'rxjs';
import { NzFormModule } from 'ng-zorro-antd/form';
import { NzInputModule } from 'ng-zorro-antd/input';
import { NzInputNumberModule } from 'ng-zorro-antd/input-number';
import { NzModalRef, NzModalService } from 'ng-zorro-antd/modal';

import { BaseComponent } from '../base-component/base-component.component';
import { NzButtonModule } from 'ng-zorro-antd/button';
import { NzDatePickerModule } from 'ng-zorro-antd/date-picker';
import { SsnValidator } from './ssn-validator';
import { EmployeeService } from '../employee.service';
import { EmployeeDetails, IEmployeeDetails } from '../clients/client';

@Component({
  selector: 'app-add-employee-modal',
  templateUrl: './add-employee-modal.component.html',
  styleUrls: ['./add-employee-modal.component.scss'],
  imports: [FormsModule, ReactiveFormsModule, NzFormModule, NzInputModule,
    NzInputNumberModule, NzButtonModule, NzDatePickerModule],
  providers: [NzModalService],
})
export class AddEmployeeModalComponent extends BaseComponent {

  private fb = inject(NonNullableFormBuilder);
  private ssnValidator = inject(SsnValidator);

  openModal = input<boolean>(false);
  addEmployee = output<EmployeeDetails>();

  modalClosed = output();

  modalRef: NzModalRef | undefined;

  ssnRegex: RegExp = /^[0-9]{3}-[0-9]{2}-[0-9]{4}$/;
  phoneNumberRegex: RegExp = /^[0-9]{10}$/;
  zipCodeRegex: RegExp = /^[A-Za-z0-9\s\-]{3,10}$/

  get ssn() {
    return this.employeeForm.get('ssn');
  }

  get phoneNumber() {
    return this.employeeForm.get('phoneNumber');
  }

  get zipCode() {
    return this.employeeForm.get('zipCode');
  }

  get dob() {
    return this.employeeForm.get('dob');
  }

  get joinDate() {
    return this.employeeForm.get('joinDate');
  }

  employeeForm = this.fb.group({
    position: this.fb.control('', [Validators.required]),
    name: this.fb.control('', [Validators.required]),
    ssn: this.fb.control<''>('', {
      asyncValidators: [this.ssnValidator.validate.bind(this.ssnValidator)],
      updateOn: 'blur',
      validators: [Validators.pattern(this.ssnRegex), Validators.required],
    }),

    phoneNumber: this.fb.control('', {
      validators: [Validators.pattern(this.phoneNumberRegex), Validators.required],
      updateOn: 'blur',
    }),
    address: this.fb.control('', [Validators.required]),
    city: this.fb.control('', [Validators.required]),
    state: this.fb.control('', [Validators.required]),
    zipCode: this.fb.control('', {
      validators: [Validators.pattern(this.zipCodeRegex), Validators.required],
      updateOn: 'blur',
    }),
    dob: this.fb.control<Date | null>(null, {
      validators: [Validators.required, this.dobValidator()],
      updateOn: 'blur',
    }),
    joinDate: this.fb.control<Date | null>(null, {
      validators: [Validators.required, this.joinDateValidator()],
      updateOn: 'blur',
    }),
    salary: this.fb.control<number | null>(null, [Validators.required]),
  });

  employeeContent = viewChild<TemplateRef<HTMLElement>>('addEmployeeContent');

  constructor(private _nzModalService: NzModalService, private _employeeService: EmployeeService) {
    super();

    effect(() => {
      if (this.openModal()) {
        this.modalRef = this._nzModalService.create({
          nzTitle: 'Add Employee Details',
          nzContent: this.employeeContent(),
          nzFooter: null,
          nzDraggable: true,
          nzWidth: 800,
          nzOnCancel: () => {
            this.cleanState();
            this.modalClosed.emit();
          },
        })
      }
    });
  }

  submitForm(): void {
    if (this.employeeForm.valid) {

      const formValues = this.employeeForm.value;

      let employeeDetails: IEmployeeDetails = {
        name: formValues.name,
        currentTitle: formValues.position,
        ssn: formValues.ssn,
        phone: formValues.phoneNumber,
        address: formValues.address,
        city: formValues.city,
        state: formValues.state,
        currentSalary: formValues.salary || undefined,
        zip: formValues.zipCode,
        dob: formValues.dob || undefined,
        joinDate: formValues.joinDate || undefined
      }

      this._employeeService.addEmployee(new EmployeeDetails(employeeDetails))
        .pipe(takeUntil(this.destroyed$))
        .subscribe((employee: EmployeeDetails) => {
          this.addEmployee.emit(employee);
          this.modalRef?.close()
          this.modalClosed.emit();
        });
    } else {
      Object.values(this.employeeForm.controls).forEach(control => {
        if (control.invalid) {
          control.markAsDirty();
          control.updateValueAndValidity({ onlySelf: true });
        }
      });
    }
  }


  cleanState(): void {
    this.employeeForm.reset();
  }

  calculateAge(dateOfBirth: Date, currentDate: Date = new Date()): number {
    // Make a copy of the dates to avoid modifying the original parameters
    const birthDate = new Date(dateOfBirth);
    const today = new Date(currentDate);

    // Get the year difference
    let age = today.getFullYear() - birthDate.getFullYear();

    // Check if birthday has occurred this year
    const hasBirthdayOccurred =
      today.getMonth() > birthDate.getMonth() ||
      (today.getMonth() === birthDate.getMonth() && today.getDate() >= birthDate.getDate());

    // Adjust age if birthday hasn't occurred yet this year
    if (!hasBirthdayOccurred) {
      age--;
    }

    return age;
  }

  dobValidator(): ValidatorFn {
    return (control: AbstractControl): ValidationErrors | null => {
      //check if the dob is between 22 and 64 years
      const dob = control.value;
      if (dob) {
        const today = new Date();
        const birthDate = new Date(dob);

        if (dob > today) {
          return { futureDate: true };
        }

        const age = this.calculateAge(birthDate, today);
        if (age < 22 || age > 64) {
          return { age: true };
        }
      }
      return null; // Valid age
    };
  }

  joinDateValidator(): ValidatorFn {
    return (control: AbstractControl): ValidationErrors | null => {
      const joinDate = new Date(control.value).setHours(0, 0, 0, 0);
      const today = new Date().setHours(0, 0, 0, 0);

      if (joinDate < today) {
        return { pastDate: true };
      }

      return null; // Valid join date
    }
  }
}
