<script lang="ts">
	import { enhance } from "$app/forms"
	import DeleteButton from "$components/DeleteButton.svelte"
	import ForumReply from "$components/ForumReply.svelte"
	import type { Reply, UserType } from "$components/ForumReply.svelte"
	import PinButton from "$components/PinButton.svelte"
	import ReportButton from "$components/ReportButton.svelte"
	import User from "$components/User.svelte"

	let {
		user,
		reply = $bindable(),
		depth = 0,
		replyingTo = $bindable(),
		postAuthorName,
		categoryName = "",
		postId,
		assetSlug = "",
		repliesCollapsed = $bindable(),
		topLevel = true,
		pinnable = false,
		refreshReplies
	}: {
		user: UserType
		reply: Reply
		depth?: number
		replyingTo: string
		postAuthorName: string
		categoryName?: string
		postId: string
		assetSlug?: string
		repliesCollapsed: { [id: string]: boolean }
		topLevel?: boolean
		pinnable?: boolean
		refreshReplies: import("@sveltejs/kit").SubmitFunction
	} = $props()

	const baseUrl = categoryName
		? `forum/${categoryName.toLowerCase()}/${postId}`
		: `catalog/${postId}/${assetSlug}`

	let content = $state("") // Allows current reply to not be lost on clicking to another reply

	let hidden = $derived(reply.visibility !== "Visible")

	const likeEnhance: import("@sveltejs/kit").SubmitFunction = ({
		formData
	}) => {
		const action = formData.get("action")

		if (action === "like") {
			reply.likes = true

			if (reply.dislikes) reply.score++
			reply.dislikes = false
			reply.score++
		} else if (action === "dislike") {
			reply.dislikes = true

			if (reply.likes) reply.score--
			reply.likes = false
			reply.score--
		} else if (action === "unlike") {
			reply.likes = false
			reply.score--
		} else if (action === "undislike") {
			reply.dislikes = false
			reply.score++
		}

		return () => {}
	}
</script>

<div class="flex w-full">
	<div class="w-full">
		<div class="flex items-center pt-2">
			<a
				href="/user/{reply.author.username}"
				class={[
					"userlink items-center no-underline flex flex-row font-bold",
					{
						[assetSlug ? "text-yellow-500" : "text-blue-600"]:
							reply.author.username === postAuthorName,
						"light-text": reply.author.username !== postAuthorName,
						"opacity-33": hidden,
						"pl-4": !topLevel
					}
				]}>
				{#if topLevel}
					<User
						user={reply.author}
						thin
						size="1.5rem"
						image
						class="pr-4" />
				{/if}
				{reply.author.username}
				{#if reply.author.username === postAuthorName}
					<fa
						class="{assetSlug
							? 'fa-hammer'
							: 'fa-microphone'} pl-2">
					</fa>
				{/if}
			</a>
			<small class="light-text pl-6">
				{reply.created.toLocaleString()}
			</small>
		</div>
		<p class={["py-2 m-0 break-all", { "opacity-33": hidden }]}>
			{reply.content[0].text}
		</p>
		{#if replyingTo !== reply.id}
			<form
				use:enhance={likeEnhance}
				method="POST"
				action="?/like&rid={reply.id}"
				class={["inline pr-2", { "opacity-33": hidden }]}>
				<button
					name="action"
					value={reply.likes ? "unlike" : "like"}
					aria-label={reply.likes ? "Unlike" : "Like"}
					class="size-6 p-0 btn">
					<fa
						fa-thumbs-up
						class="transition {reply.likes
							? 'text-emerald-600 hover:text-emerald-300'
							: 'text-neutral-600 hover:text-neutral-400'}">
					</fa>
				</button>
				<span
					class={[
						"text-center",
						{
							"text-emerald-600 font-bold": reply.likes,
							"text-red-500 font-bold": reply.dislikes
						}
					]}>
					{reply.score}
				</span>
				<button
					name="action"
					value={reply.dislikes ? "undislike" : "dislike"}
					aria-label={reply.dislikes ? "Undislike" : "Dislike"}
					class="btn size-6 p-0">
					<fa
						fa-thumbs-down
						class="transition {reply.dislikes
							? 'text-red-500 hover:text-red-300'
							: 'text-neutral-600 hover:text-neutral-400'}">
					</fa>
				</button>
			</form>
			{#if !hidden}
				<a
					href="/forum/{categoryName}/{postId}/{reply.id}"
					onclick={e => {
						e.preventDefault()
						replyingTo = reply.id
					}}
					class={[
						"btn btn-sm p-0 px-1 text-neutral-5 hover:text-neutral-300",
						{ "opacity-33": hidden }
					]}>
					<fa fa-message class="pr-2"></fa>
					Reply
				</a>
				<span class="dropdown">
					<fa fa-ellipsis-h class="dropdown-ellipsis"></fa>
					<div class="dropdown-content pt-2">
						<ul class="p-2 rounded-3">
							{#if reply.author.username === user.username}
								<DeleteButton id={reply.id} {refreshReplies} />
							{:else}
								<ReportButton
									user={reply.author.username}
									url="/forum/{categoryName}/{postId}/{reply.id}" />
								{#if user.permissionLevel >= 4}
									<DeleteButton
										id={reply.id}
										moderate
										{refreshReplies} />
								{/if}
							{/if}
							{#if pinnable && user.permissionLevel >= 4}
								<PinButton
									{refreshReplies}
									id={reply.id}
									pinned={reply.pinned} />
							{/if}
						</ul>
					</div>
				</span>
			{/if}
		{:else}
			<div class="card reply bg-darker p-4 pt-2 max-w-3/4">
				<form
					use:enhance={e => {
						replyingTo = ""
						return refreshReplies(e)
					}}
					method="POST"
					action="?/reply&rid={reply.id}">
					<label for="content" class="light-text pb-2">
						Post a Reply
					</label>
					<fieldset class="flex flex-col gap-3">
						<textarea
							bind:value={content}
							required
							minlength="1"
							maxlength="1000"
							name="content"
							placeholder="What are your thoughts?"
							rows="4">
						</textarea>
						<div class="flex gap-3">
							<button class="btn btn-secondary">
								<fa fa-message class="pr-2"></fa>
								Reply
							</button>
							<button
								onclick={() => {
									replyingTo = ""
								}}
								class="btn btn-tertiary grey-text">
								<fa fa-cancel class="pr-2"></fa>
								Cancel
							</button>
						</div>
					</fieldset>
				</form>
			</div>
		{/if}
		{#if topLevel}
			<!-- Pls give snippets svelte -->
			<noscript>
				<div class="card reply bg-darker p-4 pt-2 max-w-3/4">
					<form
						use:enhance
						onsubmit={() => {
							replyingTo = ""
						}}
						method="POST"
						action="?/reply&rid={reply.id}">
						<label for="content" class="light-text pb-2">
							Post a Reply
						</label>
						<fieldset class="flex flex-col gap-3">
							<textarea
								bind:value={content}
								required
								minlength="1"
								maxlength="1000"
								name="content"
								placeholder="What are your thoughts?"
								rows="4">
							</textarea>
							<div class="flex gap-3">
								<button class="btn btn-secondary">
									<fa fa-message class="pr-2"></fa>
									Reply
								</button>
								<button
									onclick={() => {
										replyingTo = ""
									}}
									class="btn btn-tertiary grey-text">
									<fa fa-cancel class="pr-2"></fa>
									Cancel
								</button>
							</div>
						</fieldset>
					</form>
				</div>
			</noscript>
		{/if}
	</div>
</div>

{#if depth > 8}
	<a href="/{baseUrl}/{reply.id}" class="no-underline py-2">
		<fa fa-arrow-down class="pr-2"></fa>
		More replies
	</a>
{/if}

{#each reply.replies as _, num}
	<!-- Get READY for some RECURSION!!! -->
	<ForumReply
		{user}
		bind:reply={reply.replies[num]}
		{num}
		bind:replyingTo
		{categoryName}
		{postId}
		{assetSlug}
		{postAuthorName}
		bind:repliesCollapsed
		depth={depth + 1}
		topLevel={false}
		{refreshReplies} />
{/each}

<style>
	.reply {
		border-color: var(--accent2);
	}

	.userlink {
		transition: color 0.2s;
		&:hover {
			color: var(--grey-text) !important;
		}
	}
</style>
