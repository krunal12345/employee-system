import { ChangeDetectionStrategy, Component, signal } from '@angular/core';

import { takeUntil } from 'rxjs';
import { NzTableModule } from 'ng-zorro-antd/table';

import { SearchInputComponent } from '../search-input/search-input.component';
import { EmployeeService } from '../employee.service';
import { BaseComponent } from '../base-component/base-component.component';
import { PositionDetails } from '../clients/client';
import { cloneDeep } from 'lodash';

@Component({
  selector: 'app-positions-list',
  templateUrl: './positions-list.component.html',
  styleUrls: ['./positions-list.component.scss'],
  imports: [NzTableModule, SearchInputComponent],

  changeDetection: ChangeDetectionStrategy.OnPush
})
export class PositionsListComponent extends BaseComponent {

  positionList = signal<PositionDetails[]>([]);
  positionsSnapShot: PositionDetails[] = [];

  pageSize: number = Infinity;

  constructor(private _employeeService: EmployeeService) {
    super();

    this._employeeService.getPositions()
      .pipe(takeUntil(this.destroyed$))
      .subscribe((positions: PositionDetails[]) => {
        this.positionList.set(positions);
        this.positionsSnapShot = cloneDeep(positions);
      });
  }

  searchPosition(searchTerm: string): void {
    if (searchTerm != '') {
      const filteredList = this.positionsSnapShot
        .filter((position: PositionDetails) =>
          position.title?.toLowerCase()?.includes(searchTerm.toLowerCase()));
      this.positionList.set(filteredList);
    } else {
      this.positionList.set(cloneDeep(this.positionsSnapShot));
    }
  }

  clearSearch(): void {
    this.positionList.set(cloneDeep(this.positionsSnapShot));
  }


}
