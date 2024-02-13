import { Resource } from "./resource.model";
import { User } from "./user.model";

export interface Reservation {
    reservationId: number;
    usersId: number;
    startDateTime: Date;
    endDateTime: Date;
    ResourceId: number;
    IsDeletedAdmin: boolean;
    IsDeletedResource: boolean;
    IsDeletedBuilding: boolean;
    IsDeletedNotValid: boolean;
    IsDeletedUser: boolean;
}

export interface ExpandedReservation {
    ReservationId: number;
    StartDateTime: string;
    EndDateTime: string;
    ResourceId: number;
    IsDeletedAdmin: boolean;
    IsDeletedResource: boolean;
    IsDeletedBuilding: boolean;
    IsDeletedNotValid: boolean;
    IsDeletedUser: boolean;
    Resource: {
        ResourceId: number;
        Name: string;
        Description: string;
        PosX: number;
        PosY: number;
        BuildingId: number;
        IsDeleted: boolean;
        IsDeletedBuilding: boolean;
        ResourceType: 0 | 1 | 2
        SeatsNumber: number;
    };
    Users: {
        UserId: number;
        Email: string;
        IsDeleted: boolean;
    }[];

}



export interface ReservationImage {
    reservationId: number,
    images: string[]
}