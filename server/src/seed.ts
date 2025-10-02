import { Logger } from '@nestjs/common'
import { PrismaClient } from '@prisma/client'

import 'dotenv/config'

const prisma = new PrismaClient()

async function main() {
	// TODO: seed
}

main()
	.catch(e => {
		Logger.error(e)
		process.exit(1)
	})
	.finally(async () => {
		await prisma.$disconnect()
	})
