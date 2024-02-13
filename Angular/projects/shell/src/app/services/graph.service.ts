import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment.development';
import { User, UserGraph } from '../models/user.model';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class GraphService {
  backUrl: string = environment.backEndUrl + 'api/User';
  url: string = environment.graphapis.v1.url;

  constructor(
    private http: HttpClient
  ) { }

  getPhoto() {
    return this.http.get(environment.graphapis.photo.url, {
      responseType: 'blob'
    })
  }

  getUserPhotoByEmail(email: string){
    return this.http.get(this.url + "/users/" + email + "/photo/$value", {responseType: 'blob'})
  }


  GetByEmailGraph(email: string): Observable<UserGraph> { // tutte
    return this.http.get<UserGraph>(this.backUrl + "/GetByIdGraph?email="+ email);
  }

}
