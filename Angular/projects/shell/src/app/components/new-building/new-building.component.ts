import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FormControl, FormGroup, FormsModule, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { BuildingService } from '../../services/building.service';
import { HttpClientModule } from '@angular/common/http';
import { Building } from '../../models/building.model';
import { Router } from '@angular/router';
import { ResourceMapComponent } from '../resource-map/resource-map.component';
import { MatTooltipModule } from '@angular/material/tooltip';
import { ToastrModule, ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-new-building',
  standalone: true,
  imports: [MatFormFieldModule, MatInputModule, MatTooltipModule, MatIconModule, MatButtonModule, FormsModule, ReactiveFormsModule, CommonModule, HttpClientModule, ResourceMapComponent, ToastrModule],
  providers: [BuildingService],
  templateUrl: './new-building.component.html',
  styleUrl: './new-building.component.css',
})
export class NewBuildingComponent {
  axisX: number = 10;
  axisY: number = 10;
  isMap: boolean = false;

  constructor(public buildingService: BuildingService, private toastr: ToastrService,
    public router: Router,
  ) { }
  form = new FormGroup({
    buildingName: new FormControl(
      '',
      [
        Validators.required,
        Validators.minLength(3),
        Validators.maxLength(20),
      ]),
    imageLink: new FormControl(),
    mapLink: new FormControl(),
  });

  get f() {
    return this.form.controls;
  }

  submit() {
    let building: Building = {
      buildingId: 0,
      name: this.form.value.buildingName!,
      axisX: +this.axisX!,
      axisY: +this.axisY!,
      imageLink: this.form.value.imageLink != null ? this.form.value.imageLink : "",
      mapLink: this.form.value.mapLink != null ? this.form.value.mapLink : "",
      isDeleted: false
    }

    this.buildingService.create(building).subscribe(
      x => {
        this.toastr.success('Building created successfully');
        // 

        this.router.navigate(["/building-list"]);
      },
      err => {
        this.toastr.error(err);
      }
    )
  }

  showMap() {
    this.isMap = !this.isMap;
    setTimeout(() => {
      this.isMap = !this.isMap;

    }, 1000);

  }
}
