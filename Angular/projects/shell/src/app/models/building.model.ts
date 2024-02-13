export interface Building {
    buildingId: number;
    name: string;
    imageLink: string | null;
    mapLink: string | null;
    axisX: number;
    axisY: number;
    isDeleted: boolean;
}