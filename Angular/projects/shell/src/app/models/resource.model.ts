export interface Resource {
    resourceId: number;
    name: string;
    description: string;
    posX: number;
    posY: number;
    buildingId: number;
    isDeleted: boolean;
    resourceType: 0 | 1 | 2;
    seatsNumber: number;
}
export interface ResourcePosition {
    resourceId: number;
    name: string;
    description: string;
    positions: number[][]
    buildingId: number;
    isDeleted: boolean;
    resourceType: 0 | 1 | 2;
    seatsNumber: number;
    isPlaced?: boolean;
}
export interface UpdateResource {
    resourceId: number;
    name: string;
    description: string;
    seatsNumber: number;
}

export function mapResourceToResourcePosition(resource: Resource, positionArray: number[][]): ResourcePosition {
    const positions = positionArray;

    return {
        ...resource,
        positions
    };
}
export function mapResourcePositionToResource(resourcePosition: ResourcePosition): Resource {
    return {
        resourceId: resourcePosition.resourceId,
        name: resourcePosition.name,
        description: resourcePosition.description,
        posX: 0,
        posY: 0,
        buildingId: resourcePosition.buildingId,
        isDeleted: resourcePosition.isDeleted,
        resourceType: resourcePosition.resourceType,
        seatsNumber: resourcePosition.seatsNumber,
    };

}