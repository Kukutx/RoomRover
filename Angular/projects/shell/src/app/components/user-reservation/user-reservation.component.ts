import { CommonModule } from '@angular/common';
import { HttpClient, HttpClientModule } from '@angular/common/http';
import { Component, Input, OnDestroy } from '@angular/core';
import { ReservationService } from '../../services/reservation.service';
import { ActivatedRoute, Router } from '@angular/router';
import { ExpandedReservation } from '../../models/reservation.model';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';
import { MatTooltipModule } from '@angular/material/tooltip';
import { ToastrService } from 'ngx-toastr';
import { ResourceService } from '../../services/resource.service';

@Component({
  selector: 'app-user-reservation',
  standalone: true,
  imports: [CommonModule, HttpClientModule, MatSlideToggleModule, MatTooltipModule],
  providers: [ReservationService, ResourceService],
  templateUrl: './user-reservation.component.html',
  styleUrl: './user-reservation.component.css'
})
export class UserReservationComponent implements OnDestroy {
  list = [1, 1, 1, 1, 1, 1, 1]

  // @Input() idResource?: number;

  private sub: any;
  reservations: ExpandedReservation[] = [];

  constructor(
    private rs: ReservationService,
    private resSer: ResourceService,
    private route: ActivatedRoute,
    private toastr: ToastrService,
    public router: Router,
  ) {    
    this.sub = this.route.params.subscribe(params => {
      const id = +params['id'];

      this.router.routeReuseStrategy.shouldReuseRoute = () => false;
      this.router.onSameUrlNavigation = 'reload';
    });
    this.get();
  }
  ngOnDestroy(): void {
    this.sub.unsubscribe();
  }


  get(id?: number) {
    this.rs.getByUserId(+this.route.snapshot.paramMap.get("id")!).subscribe(x => {
      this.reservations = x;
    })
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

  goToUser(id: number) {
    // console.log("user");
    this.router.navigate(["/user-detail/" + id]);
  }

}
