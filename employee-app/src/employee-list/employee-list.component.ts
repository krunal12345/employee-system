import { ChangeDetectionStrategy, Component, signal, ViewEncapsulation } from '@angular/core';
import { DatePipe } from '@angular/common';

import { takeUntil } from 'rxjs';
import { cloneDeep } from 'lodash';
import { NzTableModule } from 'ng-zorro-antd/table';
import { NzButtonModule } from 'ng-zorro-antd/button';
import { NzGridModule } from 'ng-zorro-antd/grid';

import { BaseComponent } from '../base-component/base-component.component';
import { EmployeeDetails } from '../clients/client';
import { EmployeeService } from '../employee.service';
import { SearchInputComponent } from '../search-input/search-input.component';
import { AddEmployeeModalComponent } from '../add-employee-modal/add-employee-modal.component';

@Component({
  selector: 'app-employee-list',
  templateUrl: './employee-list.component.html',
  styleUrls: ['./employee-list.component.scss'],
  imports: [NzTableModule, DatePipe, SearchInputComponent, NzButtonModule, NzGridModule, AddEmployeeModalComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  encapsulation: ViewEncapsulation.None
})
export class EmployeeListComponent extends BaseComponent {

  employeesList = signal<EmployeeDetails[]>([]);
  employeeListSnapshot: EmployeeDetails[] = [];
  isAddEmployeeModalOpen = signal<boolean>(false);
  clearSearchText = signal<boolean>(false);

  pageSize = Infinity;

  searchDeounceTimeId: number | undefined = undefined;

  constructor(private _employeeService: EmployeeService) {
    super();

    this._employeeService.getEmployees().pipe(takeUntil(this.destroyed$))
      .subscribe((employees: EmployeeDetails[]) => {
        this.employeesList.set(employees);
        this.employeeListSnapshot = cloneDeep(employees);
      });
  }

  searchEmployee(value: string): void {

    if (value !== '') {
      this.employeesList.set(
        cloneDeep(this.employeeListSnapshot
          .filter((employee: EmployeeDetails) => {
            return employee.name?.toLowerCase()?.includes(value.toLowerCase()) ||
              employee.currentTitle?.toLowerCase()?.includes(value.toLowerCase())
          })));
    } else {
      this.employeesList.set(cloneDeep(this.employeeListSnapshot));
    }
  }

  clearSearch(): void {
    this.employeesList.set(cloneDeep(this.employeeListSnapshot));
  }

  onAddEmployee(): void {
    this.isAddEmployeeModalOpen.set(true);
  }

  addEmployeeModalClose(): void {
    this.isAddEmployeeModalOpen.set(false);
  }

  addEmployee(employee: EmployeeDetails): void {
    this.employeeListSnapshot.push(employee);
    this.clearSearchText.set(true);
  }
}
