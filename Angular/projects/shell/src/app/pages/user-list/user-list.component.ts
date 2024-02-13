import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';
import { MatTabsModule } from '@angular/material/tabs';
import { DxButtonModule, DxDataGridModule, DxSelectBoxModule, DxCheckBoxModule, DxDataGridComponent } from 'devextreme-angular';
import { BuildingService } from '../../services/building.service';
import { UserService } from '../../services/user.service';
import DataSource from 'devextreme/data/data_source';
import ODataStore from 'devextreme/data/odata/store';
import { Router } from '@angular/router';
import { HttpClientModule } from '@angular/common/http';
import { UserGraph } from '../../models/user.model';
import { GraphService } from '../../services/graph.service';

@Component({
  selector: 'app-user-list',
  standalone: true,
  imports: [
    MatIconModule,
    CommonModule,
    MatTabsModule,
    DxButtonModule,
    DxDataGridModule,
    DxSelectBoxModule,
    DxCheckBoxModule,
    HttpClientModule],
  providers: [UserService, DxDataGridComponent],
  templateUrl: './user-list.component.html',
  styleUrl: './user-list.component.css'
})
export class UserListComponent {


  imageLinks: string[] = [];
  dsUser: any;
  constructor(
    public userService: UserService,
    public router: Router,
    private gs: GraphService,

  ) {
    this.dsUser = new DataSource({
      store: new ODataStore({
        url: `${this.userService.odataUrl}`,
        key: 'UserId',
        keyType: 'Int32',
        version: 4,
      }),
    });

    
    setTimeout(() => {
      
      this.dsUser._items.forEach((u: any) => {
        this.getPhoto(u.Email);
      });
  
    }, 1000);

  }

  urlImgWiki: string =
    "https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png";

  getPhoto(email: string) {
    if (email.includes("@")) {
      this.gs.getUserPhotoByEmail(email).subscribe({
        next: (x) => {
          this.imageLinks.push(URL.createObjectURL(x));

          // this.loadUser = false;
        },
        error: (e) => {
          this.imageLinks.push(this.urlImgWiki);
          // this.loadUser = false;
        },
      });
    }
  }



  openDetail(id: number) {
    this.router.navigate(["/user-detail/" + id]);

  }

}
