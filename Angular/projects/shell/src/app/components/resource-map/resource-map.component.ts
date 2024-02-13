import { CommonModule, getLocaleMonthNames } from '@angular/common';
import { HttpClientModule } from '@angular/common/http';
import { ChangeDetectorRef, Component, EventEmitter, Input, OnChanges, Output } from '@angular/core';
import { ResourceService } from '../../services/resource.service';
import { Resource, ResourcePosition, UpdateResource, mapResourcePositionToResource, mapResourceToResourcePosition } from '../../models/resource.model';
import { FormControl, FormGroup, FormsModule, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatTooltipModule } from '@angular/material/tooltip';
import { MatButtonModule } from '@angular/material/button';
import { ToastrModule, ToastrService, provideToastr } from 'ngx-toastr';
import { provideAnimations } from '@angular/platform-browser/animations';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';
import { UserReservationComponent } from '../user-reservation/user-reservation.component';

@Component({
  selector: 'app-resource-map',
  standalone: true,
  imports: [CommonModule, UserReservationComponent, MatSlideToggleModule, MatButtonModule, HttpClientModule, FormsModule, ReactiveFormsModule, MatFormFieldModule, MatInputModule, MatTooltipModule, MatIconModule, ToastrModule],
  providers: [ResourceService, provideAnimations(),],
  templateUrl: './resource-map.component.html',
  styleUrls: ['./resource-map.component.css']
})
export class ResourceMapComponent {
  @Input() x!: number;
  @Input() y!: number;
  @Input() buildingId!: number;
  @Input() mapLink!: string | null;
  @Input() isEditMap!: boolean;

  resourceName: string = '';
  resources: Resource[] = [];
  resourcePositions: ResourcePosition[] = [];

  resource: Resource = {
    resourceId: 0,
    name: "",
    description: "",
    posX: 0,
    posY: 0,
    buildingId: 0,
    isDeleted: false,
    resourceType: 0,
    seatsNumber: 0
  };

  cells: boolean[][] = [];
  phoneBootBlock: boolean[][] = [[false, false], [false, false]];
  roomBlock: boolean[][] = [[false, false, false], [false, false, false], [false, false, false]];
  selectedResource: 0 | 1 | 2 | null = null;
  hover: number[] = [-1];
  hovers: number[][] = [];
  // existingResourcePositions: number[][] = [];
  placedResources: number[][] = [];
  hasPlacedResource: boolean = false;
  newResource!: Resource;
  hasClicked: boolean = false;
  hasSelectedResource: boolean = false;
  hasUpdate: boolean = false;


  constructor(private cd: ChangeDetectorRef, public resourceService: ResourceService, private toastr: ToastrService) {
    //////console.log(this.roomBlock);
  }


  getResource() {
    if (this.buildingId === undefined)
      return
    this.resourceService.getResourceByBuildingId(this.buildingId).subscribe(x => {
      this.resources = x;
      let row: number[] = [];
      //console.log(this.resources);

      // this.existingResourcePositions = [];
      this.resourcePositions = [];
      this.resources.forEach(element => {
        //console.log("element", element);
        row = [element.posX, element.posY];
        // this.existingResourcePositions = (this.existingResourcePositions || []).concat(this.nearCell(row, element.resourceType));
        this.resourcePositions.push(mapResourceToResourcePosition(element, this.nearCell(row, element.resourceType)));
        // //console.log("posizionei esistenti", this.existingResourcePositions);
      });

      //console.log(this.resourcePositions);


      this.refreshColor();
      ////console.log("this.existingResourcePositions", this.existingResourcePositions);
    },
    )
  }

  ngOnChanges(): void {
    this.selectedResource = null;
    this.initializeCells();
    this.getResource();
    this.cd.detectChanges();
    if (this.isEditMap) {

      this.resource = {
        resourceId: 0,
        name: "",
        description: "",
        posX: 0,
        posY: 0,
        buildingId: 0,
        isDeleted: false,
        resourceType: 0,
        seatsNumber: 0
      };
      this.hasPlacedResource = false;
    }


    //////console.log(this.cells);
  }

  private initializeCells(): void {
    //////console.log("map");
    //////console.log("x", this.x);
    //////console.log("y", this.y);
    for (let i = 0; i < this.x; i++) {
      this.cells[i] = [];
      for (let j = 0; j < this.y; j++) {
        this.cells[i][j] = false;
      }
    }
  }

  nearCell(array: number[], resourceType: 0 | 1 | 2) {

    let v: number[][] = [];
    if (resourceType === 2) {

      let row: number[] = [];
      row = [array[0] - 1, array[1] - 1];
      v.push(row);
      row = [array[0] - 1, array[1]];
      v.push(row);
      row = [array[0] - 1, array[1] + 1];
      v.push(row);

      row = [array[0], array[1] - 1];
      v.push(row);
      row = [array[0], array[1]];
      v.push(row);
      row = [array[0], array[1] + 1];
      v.push(row);

      row = [array[0] + 1, array[1] - 1];
      v.push(row);
      row = [array[0] + 1, array[1]];
      v.push(row);
      row = [array[0] + 1, array[1] + 1];
      v.push(row);

      return v;
    }
    if (resourceType === 1) {
      let row: number[] = [];
      row = [array[0], array[1]];
      v.push(row);
      row = [array[0], array[1] + 1];
      v.push(row);

      row = [array[0] + 1, array[1]];
      v.push(row);
      row = [array[0] + 1, array[1] + 1];
      v.push(row);
      return v;
    }
    else {
      let row: number[] = [];
      row = [array[0], array[1]];
      v.push(row);
      return v;
    }
  }

  contain(i: number, j: number, array: number[][]) {
    let check: number[] = [];
    check.push(i, j);
    let isPresent = array.some(subArray => subArray.every((value, index) => value === check[index]));
    if (isPresent) {
      return true
    }
    return false
  }

  outside(x: number, y: number): boolean {
    //console.log(x, y);
    if (x >= this.x || y >= this.y) {
      return true;
    }
    else {
      return false;
    }

  }

  onMouseOver(i: number, j: number) {
    if (this.selectedResource === null)
      return
    this.hover[0] = i;
    this.hover[1] = j;
    this.hovers = this.nearCell(this.hover, this.selectedResource!);

  }

  onMouseOut() {
    this.hover[0] = -1;
    this.hovers = [];
  }

  placeResource(i: number, j: number) {
    this.resourceForm.reset();
    this.resourceForm.get('seatsNumber')!.setValue('3');

    this.placedResources.forEach(element => {
      this.removeColor(element, 'darkslategray')
    });

    this.refreshColor();

    if (this.selectedResource === null) {
      alert("Select a resource first");
      return
    }

    this.hasPlacedResource = true;
    this.newResource = {
      buildingId: this.buildingId,
      description: '',
      isDeleted: false,
      name: '',
      posX: i,
      posY: j,
      resourceType: this.selectedResource!,
      resourceId: 0,
      seatsNumber: 0
    };


    this.placedResources = this.nearCell([i, j], this.selectedResource);
    this.placedResources.forEach(element => {
      this.updateColor(element, 'greenyellow')
    });


    this.placedResources.forEach(element => {

      // //console.log("posizione fuori: ", this.outside(element[0], element[1]));
      // //console.log("posizione gia occupata: ", this.contain(element[0], element[1], this.existingResourcePositions));

      this.refreshColor();

      this.resourcePositions.forEach(resource => {
        if (this.contain(element[0], element[1], resource.positions)) {
          this.placedResources.forEach(element => {

            this.updateColor([element[0], element[1]], 'red')
          });
          this.hasPlacedResource = false;
        }
      });

      // if (this.contain(element[0], element[1], this.existingResourcePositions)) {
      //   this.placedResources.forEach(element => {

      //     this.updateColor([element[0], element[1]], 'red')
      //   });
      //   this.hasPlacedResource = false;
      // }

      if (this.outside(element[0], element[1])) {
        //console.log("color");

        this.placedResources.forEach(element => {

          this.updateColor([element[0], element[1]], 'red')
        });
        this.hasPlacedResource = false;

      }
    });



    switch (this.selectedResource) {
      case 0: {
        ////console.log("case 0 ");
        this.newResource.resourceType = 0;
        break;
      }
      case 1: {
        this.newResource.resourceType = 1;

        ////console.log("case 1 ");
        break;
      }
      case 2: {
        this.newResource.resourceType = 2;
        //TODO change seat number
        this.newResource.seatsNumber = 2;
        ////console.log("case 2 ");
        break;
      }
      default: {
        break;
      }
    }
  }

  createResource() {

    this.newResource.resourceType = this.selectedResource!;
    this.newResource.name = this.resourceForm.value.name!;
    this.newResource.description = this.resourceForm.value.description!;
    this.newResource.seatsNumber = +this.resourceForm.value.seatsNumber!;
    this.hasClicked = true;
    //console.log(this.newResource);

    this.resourceService.create(this.newResource).subscribe(
      x => {
        this.hasPlacedResource = false
        this.toastr.success('Resource created successfully');
        ////console.log(x);
        this.getResource();
        this.resourceForm.reset();

      },
      err => {
        this.toastr.error(err);

        this.hasClicked = false
        ////console.log("errore");
        ////console.log(err);
      }
    )
  }


  resourceForm = new FormGroup({
    name: new FormControl(
      '',
      [
        Validators.required,
        Validators.minLength(3),
        Validators.maxLength(20),
      ]),
    description: new FormControl(
      '',
      [
        Validators.minLength(3),
        Validators.maxLength(200),
      ]),
    seatsNumber: new FormControl(
      '',
      [
        // Validators.min(3),
        // Validators.max(100),
      ]),
    imageLink: new FormControl(),
  });

  get f() {
    return this.resourceForm.controls;
  }

  updateColor(coordinate: number[], color: string) {
    const box = document.getElementById(this.arrayToString(coordinate));
    if (box != null) {

      box.style.backgroundColor = color;
      box.style.cursor = 'pointer';
    }

  }

  removeColor(coordinate: number[], color: string) {
    const box = document.getElementById(this.arrayToString(coordinate));

    if (box != null) {
      box.style.backgroundColor = '';

    }
  }

  arrayToString(arr: number[]): string {
    return arr.join('-');
  }

  stringToArray(str: string): number[] {
    return str.split('-').map(Number);
  }



  viewResource(i: number, j: number) {

    this.hasPlacedResource = false;
    this.hasSelectedResource = false;
    this.passValueToParent.emit(0);

    //console.log();


    this.resourcePositions.forEach(resource => {
      if (!this.contain(i, j, resource.positions)) {
        //console.log("return");

        if (resource.isDeleted) {
          resource.positions.forEach(position => {
            this.updateColor([position[0], position[1]], 'orange');

          });
        }
        else {
          resource.positions.forEach(position => {
            this.updateColor([position[0], position[1]], 'darkslategray');
          });
        }
        return
      }
      //console.log("risors");
      this.resource = mapResourcePositionToResource(resource);
      this.passValueToParent.emit(this.resource.resourceId);

      this.resourceService.resourceId = this.resource.resourceId;
      

      //console.log(this.resource);
      resource.positions.forEach(position => {
        this.updateColor([position[0], position[1]], 'purple');

      });
      this.hasUpdate = true;
      this.hasSelectedResource = true;

      this.resourceForm.get('name')!.setValue(this.resource.name);
      this.resourceForm.get('description')!.setValue(this.resource.description);
      this.resourceForm.get('seatsNumber')!.setValue(this.resource.seatsNumber.toString());
      this.hasPlacedResource = true

    });

  }

  disableOrRestore() {
    if (this.resource.isDeleted) {
      this.resourceService.restore(this.resource.resourceId).subscribe(
        x => {
          this.resource.isDeleted = false;
          this.resourcePositions.forEach(resource => {
            if (resource.resourceId === this.resource.resourceId
            )
              resource.isDeleted = false
          })
          this.toastr.success('Resource restored');
        },
        err => {
          this.toastr.error(err);
        }
      )
    }
    if (!this.resource.isDeleted) {
      this.resourceService.disable(this.resource.resourceId).subscribe(
        x => {
          this.resource.isDeleted = true;
          this.toastr.success('Resource disabled');
          this.resourcePositions.forEach(resource => {
            if (resource.resourceId === this.resource.resourceId
            )
              resource.isDeleted = true
          })
        },
        err => {
          this.toastr.error(err);
        }
      )
    }
  }

  deleteResource(id: number) {
    this.resourceService.delete(id).subscribe(
      x => {
        this.toastr.success('Resource deleted');
        this.initializeCells();
        this.getResource();
      },
      err => {
        this.toastr.error(err);
      }
    )
  }

  updateResource() {
    //console.log("update");
    let updateResouce: UpdateResource = {
      resourceId: this.resource.resourceId,
      name: this.resourceForm.value.name!,
      description: this.resourceForm.value.description!,
      seatsNumber: this.resource.seatsNumber,
    }
    //console.log(updateResouce);
    this.resourceService.update(updateResouce).subscribe(
      x => {
        // this.hasPlacedResource = false
        this.toastr.success('Resource update successfully');
        ////console.log(x);
        this.getResource();
        this.resourceForm.reset();
        this.hasUpdate = false;
        this.isEditMap = false
        this.hasSelectedResource = false;
        this.hasPlacedResource = false;



      },
      err => {
        this.toastr.error(err);

        this.hasClicked = false
        ////console.log("errore");
        ////console.log(err);
      }
    )

  }




  refreshColor() {
    this.resourcePositions.forEach(element => {
      if (element.isDeleted) {
        element.positions.forEach(x => {
          this.updateColor(x, 'orange');
        })
      }
      else {
        element.positions.forEach(x => {
          this.updateColor(x, 'darkslategray');
        })
      }
    });
  }


  @Output() passValueToParent = new EventEmitter<any>();
}