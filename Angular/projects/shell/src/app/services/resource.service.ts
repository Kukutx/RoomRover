import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment.development';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Resource, UpdateResource } from '../models/resource.model';

@Injectable({
  providedIn: 'root'
})
export class ResourceService {

  url: string = environment.backEndUrl + 'api/Resource';


  constructor(
    private http: HttpClient
  ) { }

  resourceId: number = 0;


  getAll(): Observable<Resource[]> { // tutte
    return this.http.get<Resource[]>(this.url + "/GetAll");
  }

  getById(id: number): Observable<Resource> { // tutte
    return this.http.get<Resource>(this.url + "/GetById/" + id);
  }

  getResourceByBuildingId(id: number): Observable<Resource[]> { // tutte
    return this.http.get<Resource[]>(this.url + "/getByBuildingId/" + id);
  }

  disable(id: number) {
    return this.http.delete(this.url + "/Disable/" + id, {});
  }
  delete(id: number) {
    return this.http.delete(this.url + "/Delete/" + id, {});
  }
  restore(id: number) {
    return this.http.put(this.url + "/Restore/" + id, {});
  }

  create(resouce: Resource): Observable<Resource> {
    return this.http.post<Resource>(this.url + "/Create", resouce);
  }

  update(resouce: UpdateResource) {
    return this.http.put(this.url + "/Update", resouce);
  }

}
