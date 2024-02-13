import { Routes } from '@angular/router';
import { HomeComponent } from './pages/home/home.component';
import { LoginComponent } from './pages/login/login.component';
import { BuildingListComponent } from './pages/building-list/building-list.component';
import { NewBuildingComponent } from './components/new-building/new-building.component';
import { BuildingDetailComponent } from './components/building-detail/building-detail.component';
import { ResourceMapComponent } from './components/resource-map/resource-map.component';
import { UserListComponent } from './pages/user-list/user-list.component';
import { UserDetailComponent } from './pages/user-detail/user-detail.component';
import { UserReservationComponent } from './components/user-reservation/user-reservation.component';
import { ReservationListComponent } from './pages/reservation-list/reservation-list.component';

import { authGuard } from './guards/auth.guard';

export const routes: Routes = [
    { path: '', component: BuildingListComponent, pathMatch: 'full', canActivate: [authGuard] },
    { path: 'login', component: LoginComponent, pathMatch: 'full', canActivate: [authGuard] },
    { path: 'resource-map', component: ResourceMapComponent, pathMatch: 'full', canActivate: [authGuard] },
    { path: 'new-building', component: NewBuildingComponent, pathMatch: 'full', canActivate: [authGuard] },
    { path: 'building-detail/:id', component: BuildingDetailComponent, pathMatch: 'full', canActivate: [authGuard] },
    { path: 'building-list', component: BuildingListComponent, pathMatch: 'full', canActivate: [authGuard] },
    { path: 'user-list', component: UserListComponent, pathMatch: 'full', canActivate: [authGuard] },
    { path: 'user-detail/:id', component: UserDetailComponent, pathMatch: 'full', canActivate: [authGuard] },
    { path: 'user-reservation', component: UserReservationComponent, pathMatch: 'full', canActivate: [authGuard] },
    { path: 'reservation-list', component: ReservationListComponent, pathMatch: 'full', canActivate: [authGuard] },

    {
        path: 'management',
        loadChildren: () => import('reservations/Module').then((m) => m.ManagementModule),
        canActivate: [authGuard] 
    },


];
