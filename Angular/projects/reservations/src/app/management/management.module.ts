import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RESERVATION_ROUTES } from './management.routes';
import { RouterModule } from '@angular/router';



@NgModule({
  declarations: [],
  imports: [
    CommonModule,
    RouterModule.forChild(RESERVATION_ROUTES),
  ]
})
export class ManagementModule { }
