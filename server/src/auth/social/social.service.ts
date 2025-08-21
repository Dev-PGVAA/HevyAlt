import { Injectable } from '@nestjs/common'
import { Response } from 'express'
import { PrismaService } from 'src/prisma.service'
import { UserService } from 'src/user/user.service'
import { AuthService } from '../auth.service'
import { GoogleUser } from './social.interface'

@Injectable()
export class SocialService {
	constructor(
		private userService: UserService,
		private authService: AuthService,
		private prisma: PrismaService
	) {}
	private async getEmailSocialAuth(email: string) {
		const { password, createdAt, updatedAt, ...user } =
			await this.prisma.user.findUnique({
				where: { email: email }
			})

		return { ...user }
	}

	async googleLogin(data: GoogleUser, res: Response) {
		if (!data) throw new Error('No user from google')

		const oldUser = await this.userService.getByEmail(data.user.email)

		if (!oldUser) {
			await this.prisma.user.create({
				data: {
					email: data.user.email,
					name: `${data.user.firstName} ${data.user.lastName}`,
					avatar: data.user.picture,
					birthday: new Date(Date.now())
				}
			})
		}

		const user = await this.getEmailSocialAuth(data.user.email)

		const tokens = await this.authService.issueTokens(user.id, user.role)
		this.authService.addRefreshTokenToResponse(res, tokens.refreshToken)

		res.redirect(`${process.env.CLIENT_URL}/auth/social-auth?accessToken=${tokens.accessToken}`)
	}
}
