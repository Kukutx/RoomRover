import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { MatTooltipModule } from '@angular/material/tooltip';
import { UserService } from '../../services/user.service';
import { ActivatedRoute } from '@angular/router';
import { User, UserGraph } from '../../models/user.model';
import { HttpClientModule } from '@angular/common/http';
import { UserReservationComponent } from '../../components/user-reservation/user-reservation.component';
import { GraphService } from '../../services/graph.service';


@Component({
  selector: 'app-user-detail',
  standalone: true,
  imports: [CommonModule, MatIconModule, MatCardModule, MatTooltipModule, HttpClientModule, UserReservationComponent],
  providers: [UserService,],
  templateUrl: './user-detail.component.html',
  styleUrl: './user-detail.component.css'
})
export class UserDetailComponent {

  user: User = {
    userId: 0,
    email: '',
    isDeleted: false,

  };
  userGraph: UserGraph = {
    email: "",
    jobTitle: "",
    name: "",
    officeLocation: "",
    surname: "",
  };

  constructor(
    private us: UserService,
    private route: ActivatedRoute,
    private gs: GraphService,
    // private toastr: ToastrService,
  ) {
    this.us.getById((+this.route.snapshot.paramMap.get("id")!)).subscribe(
      x => {
        this.user = x;
        this.getPhoto();

        this.gs.GetByEmailGraph(this.user.email).subscribe(x => {
          this.userGraph = x;
        })
      }
    )
  }

  urlImgWiki: string =
    "https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png";

  getPhoto() {
    if (this.user.email.includes("@")) {
      this.gs.getUserPhotoByEmail(this.user.email).subscribe({
        next: (x) => {
          this.user.imageLink = URL.createObjectURL(x);

          // this.loadUser = false;
        },
        error: (e) => {
          this.user.imageLink = this.urlImgWiki;
          // this.loadUser = false;
        },
      });
    }
  }

}
