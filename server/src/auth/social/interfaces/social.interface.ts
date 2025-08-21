export interface GoogleUser {
	user: {
		email: string
		firstName: string
		lastName: string
		picture: string
	}
}

export interface GithubUser {
	user: {
		displayName: string
		username: string
		photos: [
			{
				value: string
			}
		]
	}
}
