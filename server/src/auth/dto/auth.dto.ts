import { IsEmail, IsString, MinLength } from 'class-validator'

export class AuthRegisterDto {
	@IsString()
	name: string

	@IsEmail()
	email: string

	@MinLength(6, { message: 'Password must be at least 6 characters long' })
	@IsString()
	password: string
}

export class AuthLoginDto {
	@IsEmail()
	email: string

	@MinLength(6, { message: 'Password must be at least 6 characters long' })
	@IsString()
	password: string
}

export class ForgotPasswordDto {
	@IsEmail()
	email: string

	@IsString()
	code: string
}
export class ForgotPasswordEmailDto {
	@IsEmail()
	email: string
}
