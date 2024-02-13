export interface User {
    userId: number;
    email: string;
    isDeleted: boolean;
    imageLink?: string;
}


export interface UserGraph {
    email: string,
    name: string
    surname: string
    jobTitle: string
    officeLocation: string
    imageLink?: string;

}


