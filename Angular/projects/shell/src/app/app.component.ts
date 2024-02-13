import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';
import { MatIconModule } from '@angular/material/icon';
import { ToastrService } from 'ngx-toastr';
import { routes } from './models/router.model';
import { JwtService } from './services/jwt.service';


@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    CommonModule,
    RouterOutlet,
    RouterLink,
    RouterLinkActive,
    MatIconModule,

  ],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})

export class AppComponent {
  title = 'shell';

  constructor(public router: Router, private jwtService: JwtService,) { }
  isActivePage(link: any): boolean {
    return this.router.url.startsWith(link);
  }


  ROUTES: routes[] = [
    {
      routerLink: '/new-building',
      icon: 'add',
      label: 'Add building'
    },
    {
      routerLink: '/building-list',
      icon: 'list',
      label: 'Buildings'
    },
    // {
    //   routerLink: '/user-detail',
    //   icon: 'person',
    //   label: 'My profile'
    // },
    {
      routerLink: '/user-list',
      icon: 'supervised_user_circle',
      label: 'Users'
    },
    // {
    //   routerLink: '/user-reservation',
    //   icon: 'bookmark',
    //   label: 'Reservation'
    // },
    {
      routerLink: '/reservation-list',
      icon: 'collections_bookmark',
      label: 'Reservations'
    },
    {
      routerLink: '/management/reservation/riccardo.sterchele@itsincom.it',
      icon: 'bookmark',
      label: 'Your reservation'
    },
    // {
    //   routerLink: '/login',
    //   icon: 'exit_to_app',
    //   label: 'Logout'
    // },
  ];


}
