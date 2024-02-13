import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment.development';
import { ExpandedReservation, Reservation } from '../models/reservation.model';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ReservationService {

  url: string = environment.backEndUrl + 'api/Reservation';
  odataUrl: string = environment.backEndUrl + 'odata/Reservation';

  constructor(
    private http: HttpClient
  ) { }


  getCountOfReservationByResourceId(id: number): Observable<any[]> { // tutte
    return this.http.get<any[]>(this.url + "?$expand=users,Resource&$filter=Resource/ResourceId eq "+id+"&$count=true");
  }
  getByUserId(id: number): Observable<ExpandedReservation[]> { // tutte
    return this.http.get<ExpandedReservation[]>(this.url + "?$expand=Resource&$expand=Users&$filter=Users/any(u: u/UserId eq " + id + ")");
  }
  getByEmailId(email: string): Observable<ExpandedReservation[]> { // tutte
    return this.http.get<ExpandedReservation[]>(this.url + "?$expand=Resource&$expand=Users&$filter=Users/any(u: u/Email eq '" + email + "')");
  }

  delete(id: number) {
    return this.http.delete(this.url + "/Delete/" + id, {});
  }
  disable(id: number) {
    return this.http.delete(this.url + "/Disabled/" + id, {});
  }
  restore(id: number) {
    return this.http.put(this.url + "/Restore/" + id, {});
  }

}
