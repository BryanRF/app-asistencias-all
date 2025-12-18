export declare class LoginDto {
    dni: string;
    password: string;
}
export declare class LoginResponseDto {
    access_token: string;
    user: {
        id: number;
        dni: string;
        nombres: string;
        apellidos: string;
        email: string;
        rol: string;
    };
}
