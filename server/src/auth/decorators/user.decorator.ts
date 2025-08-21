import { ExecutionContext, createParamDecorator } from '@nestjs/common'
import type { User } from 'prisma/generated/client'

export const CurrentUser = createParamDecorator(
	(data: keyof User, ctx: ExecutionContext) => {
		const req = ctx.switchToHttp().getRequest()
		const user = req.user

		return data ? user[data] : user
	}
)
