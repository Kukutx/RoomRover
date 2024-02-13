import { Routes } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { ReservationComponent } from './management/reservation/reservation.component';

export const routes: Routes = [
    { path: '', component: HomeComponent, pathMatch: 'full' },
    {
        path:'reservation',
        component: ReservationComponent
    },
    // {
    //     path:'reservation-list',
    //     component: ReservationListComponent
    // }
];
