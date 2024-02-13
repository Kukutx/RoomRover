import { Component } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { ActivatedRoute } from '@angular/router';
import { ReservationService } from '../../../../../shell/src/app/services/reservation.service';
import { CommonModule } from '@angular/common';
import { MatTooltipModule } from '@angular/material/tooltip';
import { ExpandedReservation } from '../../../../../shell/src/app/models/reservation.model';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-reservation',
  standalone: true,
  imports: [MatButtonModule, CommonModule,MatTooltipModule, MatIconModule],
  templateUrl: './reservation.component.html',
  styleUrl: './reservation.component.css'
})
export class ReservationComponent {

  reservations: ExpandedReservation[] = [];

  
  constructor(
    private route: ActivatedRoute,
    private rs: ReservationService,


  ) { this.get();}

  get() {
    this.rs.getByEmailId(this.route.snapshot.paramMap.get("email")!).subscribe(x => {
      this.reservations = x;
    })
  }

}
