<script lang="ts">
	import type { Snippet } from "svelte"

	const {
		name,
		tagline,
		descriptions,
		pad = false,
		children
	}: {
		name: string
		tagline: string
		descriptions: { [_: string]: string }
		pad?: boolean
		children?: Snippet
	} = $props()
</script>

<div class="light-text flex <lg:flex-col min-h-screen h-full overflow-auto">
	<div
		id="dark"
		class="lg:w-1/2 p-8vw pt-5vh {pad ? 'lg:pt-20vh' : 'lg:pt-12vh'}">
		<a href="/" class="btn btn-lg border-0 px-0 text-base">
			<fa fa-arrow-left class="pr-2"></fa>
			Home
		</a>
		<h1 class="font-bold text-14">{name}</h1>
		{#if tagline}
			<h2 class="font-semibold pb-3 text-12 opacity-50">
				&ndash; {tagline}
			</h2>
		{/if}
		<hr class="pt-6" />

		{#each Object.entries(descriptions) as [title, description]}
			<div class="w-full">
				<h2 class="font-semibold">{title}</h2>
				<p class="pl-4 opacity-75">{description}</p>
			</div>
		{/each}
	</div>

	<div
		id="light"
		class="lg:w-1/2 py-8vh px-8vw pt-5vh {pad
			? 'lg:pt-20vh'
			: 'lg:pt-12vh'} z-1">
		<div class="max-w-120 mx-auto">
			{@render children?.()}
		</div>
	</div>
</div>

<style>
	#light {
		/* I had no idea hsla() worked like this */
		background: radial-gradient(#ffffff1f 1px, transparent 1px),
			var(--background);
		background-size: 2rem 2rem;
		background-attachment: fixed;
		& :global(form) :global(button) {
			width: 100%;
		}
	}

	#dark {
		background: linear-gradient(
			-20deg,
			hsl(calc(var(--hue) - 5) 74% 7%) 50%,
			var(--mainaccent) 250%
		);
	}
</style>
