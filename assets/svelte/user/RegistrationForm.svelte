<script>
  let { form } = $props();

  let emailInput;

  $effect(() => {
    emailInput?.focus();
  });
</script>

<form id="registration_form" phx-submit="save" phx-change="validate">
  <fieldset class="fieldset mb-2">
    <label>
      <span class="label mb-1">Email</span>
      <input
        name="email"
        type="email"
        autocomplete="username"
        required
        bind:this={emailInput}
        bind:value={form.values.email}
        phx-debounce="200"
        class="w-full input"
      />
      {#if form.errors.email}
        <p class="mt-1.5 flex gap-2 items-center text-sm text-error">
          {form.errors.email}
        </p>
      {/if}
    </label>
  </fieldset>

  <button
    disabled={!form.valid}
    type="submit"
    class="btn btn-primary w-full"
    phx-disable-with
  >
    Create an account
  </button>
</form>
