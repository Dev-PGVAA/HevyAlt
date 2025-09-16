import {
	Injectable,
	NotFoundException,
	UnauthorizedException
} from '@nestjs/common'
import { JwtService } from '@nestjs/jwt'
import { verify } from 'argon2'
import { Response } from 'express'
import { Role } from 'prisma/generated/client'
import { PrismaService } from 'src/prisma.service'
import { UserService } from '../user/user.service'
import { AuthLoginDto, AuthRegisterDto } from './dto/auth.dto'

@Injectable()
export class AuthService {
	EXPIRE_DAY_REFRESH_TOKEN = 1
	REFRESH_TOKEN_NAME = 'refresh_token'

	constructor(
		private jwt: JwtService,
		private UserService: UserService,
		private prisma: PrismaService
	) {}

	async login(dto: AuthLoginDto) {
		const { password, ...user } = await this.validateUser(dto)
		const tokens = this.issueTokens(user.id)

		return {
			user,
			...tokens
		}
	}

	async register(dto: AuthRegisterDto) {
		const oldUserEmail = await this.UserService.getByEmail(dto.email)

		if (oldUserEmail)
			throw new UnauthorizedException('User with this email already exists')

		const { password, ...user } = await this.UserService.create(dto)

		const tokens = this.issueTokens(user.id)

		return {
			user,
			...tokens
		}
	}

	issueTokens(userId: string, role?: Role) {
		const data = { id: userId, role }

		const accessToken = this.jwt.sign(data, {
			expiresIn: '1h'
		})

		const refreshToken = this.jwt.sign(data, {
			expiresIn: '30d'
		})

		return { accessToken, refreshToken }
	}

	private async validateUser(dto: AuthLoginDto) {
		const user = await this.UserService.getByEmail(dto.email)

		if (!user) throw new NotFoundException('User not found')

		const isValid = await verify(user.password, dto.password)

		if (!isValid) throw new UnauthorizedException('Invalid password')

		return user
	}

	addRefreshTokenToResponse(res: Response, refreshToken: string) {
		const expiresIn = new Date()
		expiresIn.setDate(expiresIn.getDate() + this.EXPIRE_DAY_REFRESH_TOKEN)

		// Dev-friendly cookie (HTTP, no fixed domain). Consider using HTTPS + sameSite 'none' + secure=true in production
		res.cookie(this.REFRESH_TOKEN_NAME, refreshToken, {
			httpOnly: true,
			path: '/',
			secure: false,
			sameSite: 'lax',
			expires: expiresIn
		})
	}

	async getNewTokens(refreshToken: string) {
		const result = await this.jwt.verifyAsync(refreshToken)
		if (!result) throw new UnauthorizedException('Invalid refresh token')

		const { password, ...user } = await this.UserService.getById(result.id)

		const tokens = this.issueTokens(user.id)

		return {
			user,
			...tokens
		}
	}

	removeRefreshTokenToResponse(res: Response) {
		res.cookie(this.REFRESH_TOKEN_NAME, '', {
			httpOnly: true,
			path: '/',
			expires: new Date(0),
			secure: false,
			sameSite: 'lax'
		})
	}
}
