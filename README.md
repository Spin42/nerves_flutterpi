# NervesFlutterpi

Launch Flutterpi on Nerves

## Usage

```elixir
{NervesFlutterpi,
 flutter_app_dir: "path_to_app_in_target_rootfs",
 name: :flutterpi}
```

## Installation

Include `nerves_flutterpi` in your dependencies referencing `github`:

```elixir
def deps do
  [
    {:nerves_flutterpi, github: "SPin42/nerves_flutterpi"}
  ]
end
```
