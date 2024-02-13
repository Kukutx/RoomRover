import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { BuildingService } from '../../services/building.service';
import { Building } from '../../models/building.model';
import { HttpClientModule } from '@angular/common/http';
import { Router } from '@angular/router';
import { MatTabsModule } from '@angular/material/tabs';
import { MatIconModule } from '@angular/material/icon';
import { DxButtonModule, DxCheckBoxModule, DxDataGridComponent, DxDataGridModule, DxSelectBoxModule } from 'devextreme-angular';
import DataSource from 'devextreme/data/data_source';
import ODataStore from 'devextreme/data/odata/store';

@Component({
  selector: 'app-building-list',
  standalone: true,
  imports: [CommonModule, HttpClientModule, MatTabsModule, MatIconModule, DxButtonModule,
    DxDataGridModule,
    DxSelectBoxModule,
    DxCheckBoxModule,],
  providers: [BuildingService, DxDataGridComponent],
  templateUrl: './building-list.component.html',
  styleUrl: './building-list.component.css'
})
export class BuildingListComponent {
  buildings: Array<Building> = [];

  dsBuilding: any;

  constructor(
    public buildingService: BuildingService,
    public router: Router,

  ) {
    // this.buildingService.getAll().subscribe(x => {
    //   this.buildings = x
    //   console.log(x)
    // })
    this.dsBuilding = new DataSource({
      store: new ODataStore({
        url: `${this.buildingService.odataUrl}`,
        key: 'BuildingId',
        keyType: 'Int32',
        version: 4,
        // beforeSend: (request) => {
        //   request.headers = {
        //     "Authorization": "Bearer " + this.tokenService.readToken()
        //   };
        // }
      }),
      // filter: [
      //   [`IsDeleted`, '=', false]
      // ]
    });

  }




  goToDetail(id: number) {
    this.router.navigate(['/building-detail/' + id]);
  }

}
