import { Component, effect, input, OnInit, output, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { NzIconModule } from 'ng-zorro-antd/icon';
import { NzInputModule } from 'ng-zorro-antd/input';

@Component({
  selector: 'app-search-input',
  templateUrl: './search-input.component.html',
  styleUrls: ['./search-input.component.scss'],
  imports: [FormsModule, NzInputModule, NzIconModule],
})
export class SearchInputComponent {

  searchTerm = signal('');
  searchDeounceTimeId: number | undefined = undefined;

  clearSearchText = input<boolean>(false);
  clearSearch = output<void>();
  searchText = output<string>();

  constructor() {
    effect(() => {
      if (this.clearSearchText()) {
        this.clearClick();
      }
    })
  }

  clearClick(): void {
    this.searchTerm.set('');
    this.clearSearch.emit();
  }

  onSerachText(value: string): void {
    if (this.searchDeounceTimeId) {
      clearTimeout(this.searchDeounceTimeId);
    }

    this.searchDeounceTimeId = window.setTimeout(() => {
      this.searchText.emit(value);
    }, 700);
  }
}
