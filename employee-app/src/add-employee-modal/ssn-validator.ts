import { inject, Injectable } from '@angular/core';
import { AbstractControl, AsyncValidator, AsyncValidatorFn, ValidationErrors } from '@angular/forms';
import { EmployeeService } from '../employee.service';
import { catchError, map, Observable, of } from 'rxjs';

@Injectable({
    providedIn: 'root'
})
export class SsnValidator implements AsyncValidator {
    private readonly _employeeService = inject(EmployeeService);

    validate(control: AbstractControl): Observable<ValidationErrors | null> {
        return this._employeeService.hasSSN(control.value).pipe(
            map((isTaken) => (isTaken ? { uniqueSSN: true } : null)),
            catchError(() => of(null)),
        );
    }

}
