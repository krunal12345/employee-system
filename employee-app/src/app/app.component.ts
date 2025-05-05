import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';

import { NzTabsModule } from 'ng-zorro-antd/tabs';

import { EmployeeListComponent } from '../employee-list/employee-list.component';
import { PositionsListComponent } from '../positions-list/positions-list.component';
import { EmployeeService } from '../employee.service';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, NzTabsModule, EmployeeListComponent, PositionsListComponent],
  providers: [EmployeeService],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent {
  title = 'employee-app';
}
