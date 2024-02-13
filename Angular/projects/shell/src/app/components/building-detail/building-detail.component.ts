import { HttpClientModule } from '@angular/common/http';
import { Component } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { BuildingService } from '../../services/building.service';
import { Building } from '../../models/building.model';
import { CommonModule } from '@angular/common';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatTooltipModule } from '@angular/material/tooltip';
import { AbstractControl, FormControl, FormGroup, FormsModule, ReactiveFormsModule, ValidationErrors, Validators } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';
import { ResourceMapComponent } from '../resource-map/resource-map.component';
import { ToastrService } from 'ngx-toastr';
import { UserReservationComponent } from '../user-reservation/user-reservation.component';
import { ReservationListComponent } from '../../pages/reservation-list/reservation-list.component';

@Component({
  selector: 'app-building-detail',
  standalone: true,
  imports: [HttpClientModule, ReservationListComponent, UserReservationComponent, HttpClientModule, CommonModule, MatButtonModule, MatTooltipModule, MatIconModule, FormsModule, ReactiveFormsModule, MatFormFieldModule, MatInputModule, MatTooltipModule, MatSlideToggleModule, ResourceMapComponent],
  providers: [BuildingService,],
  templateUrl: './building-detail.component.html',
  styleUrl: './building-detail.component.css'
})
export class BuildingDetailComponent {
  id: number = 0;
  isEdit: boolean = false;
  hasClicked: boolean = false;
  isActive!: boolean;

  building: Building = this.buildingService.selectedBuilding;
  oldBuilding: Building = this.building;

  constructor(
    public router: Router,
    private route: ActivatedRoute,
    public buildingService: BuildingService,
    private toastr: ToastrService,
  ) {
    this.get();
  }

  form = new FormGroup({
    buildingName: new FormControl(
      '',
      [
        Validators.required,
        Validators.minLength(3),
        Validators.maxLength(25),
        (control: AbstractControl): ValidationErrors | null => {
          return control.value === this.oldBuilding.name ? { 'sameAsOld': true } : null;
        },
      ]),
  });

  get f() {
    return this.form.controls;
  }

  get isFormValid() {
    if (this.form.invalid && this.building.isDeleted === this.isActive) {
      return true;
    }
    else {
      return false
    }
  }

  get() {
    if (this.route.snapshot.paramMap.get("id")) {
      var idStr = this.route.snapshot.paramMap.get("id");
      if (isNaN(+idStr!)) {
        //TODO realizzare una pagina per risorsa non trovata
      } else {
        this.id = +idStr!;
        this.buildingService.getById(+idStr!).subscribe(
          x => {
            this.building = x, //success handler
              this.isActive = x.isDeleted;
          },
          err => {
          }
        )
      }
    }
  }

  save() {
    this.hasClicked = true;
    let changed: boolean = false;
    if (this.oldBuilding.name !== this.form.value.buildingName || this.form.invalid) {
      this.updateName();
      changed = true;
    }
    if (this.building.isDeleted !== this.isActive) {
      this.changeStatus();
      this.isActive = !this.isActive;
      changed = true
    }
    if (changed) {
      this.hasClicked = false;
    }
  }

  updateName() {
    this.buildingService.updateName(this.building.buildingId, this.form.value.buildingName!).subscribe(
      x => {
        this.building.name = this.form.value.buildingName!;
        this.isEdit = false
        this.toastr.success('Building update successfully');
      },
      err => {
        this.toastr.error(err);
      }
    )
  }

  changeStatus() {
    if (!this.building.isDeleted) {
      this.buildingService.restore(this.building.buildingId).subscribe(x => { this.isEdit = false })
    }
    if (this.building.isDeleted) {
      this.buildingService.softDelete(this.building.buildingId).subscribe(x => { this.isEdit = false }
      )
    }
  }
  editMode() {
    this.isEdit = !this.isEdit;
    this.oldBuilding.name = this.building.name;
    this.form.get('buildingName')!.setValue(this.building.name);
  }

  discard() {
    this.isEdit = !this.isEdit;
    this.building.isDeleted = this.isActive;
  }

  hardDelete() {
    this.buildingService.hardDelete(this.building.buildingId).subscribe(
      x => {
        this.toastr.success("Delete succesfully");
        this.router.navigate(["/building-list"]);


      },
      err => {
        this.toastr.success("Something went wrong");
      }
    )
  }




  /*  */
  valueFromParent: any = 0;

  onValuePassed(value: any) {
    this.valueFromParent = value;
  }

}
