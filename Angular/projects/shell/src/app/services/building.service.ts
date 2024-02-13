import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment.development';
import { Building } from '../models/building.model';
import { Observable } from 'rxjs';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class BuildingService {

  url: string = environment.backEndUrl + 'api/Building';
  odataUrl: string = environment.backEndUrl + 'odata/Building';

  selectedBuilding: Building = {
    buildingId: 0,
    name: '',
    imageLink: null,
    mapLink: null,
    axisX: 0,
    axisY: 0,
    isDeleted: false,
  };

  constructor(
    private http: HttpClient
  ) { }

  getAll(): Observable<Building[]> { // tutte
    return this.http.get<Building[]>(this.url + "/GetAll");
  }

  getById(id: number): Observable<Building> { // tutte
    return this.http.get<Building>(this.url + "/GetById/" + id);
  }

  updateName(id: number, name: string) {
    return this.http.put(this.url + "/Update?id=" + id + "&name="+name, {});
  }

  softDelete(id: number) {
    return this.http.delete(this.url + "/Disable/" + id, {});
  }

  hardDelete(id: number) {
    return this.http.delete(this.url + "/Delete/" + id, {});
  }

  restore(id: number) {
    return this.http.put(this.url + "/Restore/" + id, {});
  }

  create(building: Building): Observable<Building> {
    return this.http.post<Building>(this.url + "/Create", building);
  }




}
