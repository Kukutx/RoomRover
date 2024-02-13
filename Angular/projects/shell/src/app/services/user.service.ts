import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment.development';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { User } from '../models/user.model';




@Injectable({
  providedIn: 'root'
})
export class UserService {

  url: string = environment.backEndUrl + 'api/User';
  odataUrl: string = environment.backEndUrl + 'odata/User';

  constructor(
    private http: HttpClient
  ) { }

  getById(id: number): Observable<User> { // tutte
    return this.http.get<User>(this.url + "/GetById/" + id);
  }


}
