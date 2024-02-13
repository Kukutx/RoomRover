import { Routes } from "@angular/router";
import { ReservationComponent } from "./reservation/reservation.component";

export const RESERVATION_ROUTES: Routes = [
    {
        path: 'reservation/:email',
        component: ReservationComponent
    },
    // {
    //     path: 'reservation-list',
    //     component: ReservationListComponent
    // }
]