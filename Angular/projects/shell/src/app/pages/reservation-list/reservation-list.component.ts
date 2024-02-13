import { CommonModule } from '@angular/common';
import { HttpClientModule } from '@angular/common/http';
import { Component, Input } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';
import { MatTabsModule } from '@angular/material/tabs';
import { Router } from '@angular/router';
import { DxButtonModule, DxDataGridModule, DxSelectBoxModule, DxCheckBoxModule, DxDataGridComponent } from 'devextreme-angular';
import DataSource from 'devextreme/data/data_source';
import ODataStore from 'devextreme/data/odata/store';
import { ReservationService } from '../../services/reservation.service';
import { MatTooltipModule } from '@angular/material/tooltip';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';
import { ExpandedReservation, ReservationImage } from '../../models/reservation.model';
import { ToastrService } from 'ngx-toastr';
import { GraphService } from '../../services/graph.service';

@Component({
  selector: 'app-reservation-list',
  standalone: true,
  imports: [
    CommonModule,
    HttpClientModule,
    MatTabsModule,
    MatIconModule,
    DxButtonModule,
    DxDataGridModule,
    DxSelectBoxModule,
    DxCheckBoxModule,
    HttpClientModule,
    MatTooltipModule, MatSlideToggleModule],
  providers: [ReservationService, DxDataGridComponent],
  templateUrl: './reservation-list.component.html',
  styleUrl: './reservation-list.component.css'
})
export class ReservationListComponent {

  reservation: ReservationImage[] = [];



  imageLinks: string[] = [];
  dsReservation: any;
  isEmpty: boolean = true;

  constructor(
    public rs: ReservationService,
    public router: Router,
    private toastr: ToastrService,
    private gs: GraphService,
  ) {
    this.get();
  }


  get() {
    this.imageLinks =[];
    let url = `${this.rs.odataUrl}?$expand=Resource&$expand=Users`;
    if (this.valueFromParent) {
      url = `${this.rs.odataUrl}?$expand=users&$expand=Resource&$filter=Resource/ResourceId eq ${this.valueFromParent}`;
    }
    this.dsReservation = new DataSource({
      store: new ODataStore({
        url: url,
        key: 'ReservationId',
        keyType: 'Int32',
        version: 4,
      }),
    });

    setTimeout(() => {

      this.dsReservation._items.forEach((i: any) => {
        i.Users.forEach((u: any) => {
        this.getPhoto(u.Email);

        });
      });

      // console.log("datastore Users", this.dsReservation._items.Users);
      if (this.dsReservation._totalCount > 0)
        this.isEmpty = false;

    }, 400);
  }

  goToUser(id: number) {
    // console.log("user");
    this.router.navigate(["/user-detail/" + id]);
  }


  disableOrRestore(item: ExpandedReservation) {

    if (item.IsDeletedAdmin) {

      this.rs.restore(item.ReservationId).subscribe(x => { this, this.toastr.success("Restored succesfully") });
      item.IsDeletedAdmin = !item.IsDeletedAdmin;
      return
    }
    if (!item.IsDeletedAdmin) {

      this.rs.disable(item.ReservationId).subscribe(x => {
        this, this.toastr.success("Deleted succesfully");
        item.IsDeletedAdmin = !item.IsDeletedAdmin;
      }
      )
      return
    }
  }

  ngOnChanges(): void {
    this.get();

  }

  @Input() valueFromParent: any;

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


}