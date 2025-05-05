import { Injectable } from '@angular/core';

import { map, Observable } from 'rxjs';

import { Client, EmployeeDetails, PositionDetails, SwaggerResponse } from './clients/client';

@Injectable({
    providedIn: 'root'
})
export class EmployeeService {

    constructor(private _client: Client) { }

    /**
     * Retrieves a list of employees, optionally filtered by a search term.
     *
     * @param searchTerm - A string used to filter the employees by name or other criteria. 
     *                     If not provided, all employees will be retrieved.
     * @returns A observable that resolves to the list of employees matching the search criteria.
     */
    public getEmployees(searchTerm: string = ""): Observable<EmployeeDetails[]> {
        return this._client.employeesAll(searchTerm)
            .pipe(
                map((response: SwaggerResponse<EmployeeDetails[]>) => response.result)
            );
    }

    /**
     * Retrieves a list of positions, optionally filtered by a search term.
     *
     * @param searchTerm - A string used to filter the positions by name or other criteria. 
     *                     If not provided, all positions will be retrieved.
     * @returns A observable that resolves to the list of positions matching the search criteria.
     */
    public getPositions(searchTerm: string = ""): Observable<PositionDetails[]> {
        return this._client.positions(searchTerm)
            .pipe(
                map((response: SwaggerResponse<PositionDetails[]>) => response.result)
            );
    }

    /**
     * 
     * @param employee - The employee details to be added.
     *                  This object should contain all the necessary information about the employee.
     * @returns An observable that resolves to the added employee's details.
     */
    public addEmployee(employee: EmployeeDetails): Observable<EmployeeDetails> {
        return this._client.employees(employee)
            .pipe(
                map((response: SwaggerResponse<EmployeeDetails>) => response.result)
            );
    }

    /**
     * 
     * @param ssn - ssn number to check.
     *                  
     * @returns returns observale of true if the ssn exists, false otherwise.
     */
    public hasSSN(ssn: string): Observable<boolean> {
        return this._client.hasSSN(ssn)
            .pipe(
                map((response: SwaggerResponse<boolean>) => response.result)
            );
    }

}