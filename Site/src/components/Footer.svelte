<script lang="ts">
	const {
		data
	}: {
		data: import("../routes/$types").LayoutData
	} = $props()

	let clicked = $state(false)
</script>

<footer class="bg-darker relative flex justify-center <lg:pb-20!">
	<div
		class="flex <sm:flex-col justify-between items-start w-200 p-4 sm:pb-8">
		<div>
			<img
				src="/assets/icon"
				alt="{data.siteName} logo"
				class="size-8 opacity-50" />
			<a href="/" class="no-underline pl-2">{data.siteName}</a>
			{#if data.tagline}
				<span class="grey-text pl-1">&ndash;</span>
				<span class="grey-text pl-1">
					{data.tagline}
				</span>
			{/if}
		</div>
		<div class="sm:text-right <sm:pt-4">
			<div class="flex <sm:flex-col sm:gap-3 justify-end pb-2">
				{#if data.pages.includes("Statistics")}
					<a class="light-text" href="/statistics">Statistics</a>
				{/if}
			</div>
			<button
				onmousedown={() => {
					clicked = !clicked
				}}
				id="heart"
				class={[
					"grey-text border-0 p-0 cursor-pointer text-base bg-transparent",
					{ clicked }
				]}>
				<span class="grey-text s1">made with</span>
				<fa fa-heart></fa>
				<span class="grey-text s2">in 🏴󠁧󠁢󠁳󠁣󠁴󠁿</span>
			</button>
		</div>
	</div>
</footer>

<noscript>
	<div id="nojs" class="fixed bottom-0 block w-screen">
		<p class="light-text text-center">
			Javascript is disabled. You may have a diminished experience while
			using {data.siteName}.
		</p>
	</div>
</noscript>

<style>
	#heart {
		& fa {
			transition: 0.2s;
		}

		& span {
			transition: all 0.3s;
			display: inline-block;
			overflow: hidden;
			white-space: nowrap;
			width: 0;
			vertical-align: middle;
			margin-top: -0.2rem;
		}

		&:hover .s1 {
			width: 5.2rem;
			padding: 0 0.2rem;
		}
		&:hover .s2 {
			width: 2.5rem;
			padding: 0 0.2rem;
		}

		&:not(.clicked) fa:hover {
			color: var(--light-text) !important;
		}
	}

	@keyframes heart {
		0% {
			transform: scale(1);
		}
		15% {
			transform: scale(0.9);
			rotate: -10deg;
		}
		25% {
			transform: scale(1);
			rotate: 5deg;
		}
		40% {
			transform: scale(1.2);
			filter: drop-shadow(0 0 3px #f4b);
		}
		100% {
			transform: scale(1);
			rotate: 0;
		}
	}

	.clicked fa {
		animation: heart 2s;
	}
	.clicked {
		& fa,
		& span {
			color: #f4b !important;
		}
	}

	footer {
		flex-shrink: 0;
		padding: 1vh;
		& a {
			text-decoration: none;
			&:hover {
				text-decoration: underline;
			}
		}
	}

	#nojs {
		background: rgba(0, 0, 0, 0.5);
		transform: translate(0, 1rem);
	}
</style>
