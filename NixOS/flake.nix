{
	description = "A very basic flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		#nixpkgs.url = "github:nixos/nixpkgs";
    
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		#hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1?";
		#hyprland.url = "github:hyprwm/Hyprland";
		##hyprland-plugins = {
		##	url = "github:hyprwm/hyprland-plugins";
		##	inputs.hyprland.follows = "hyprland";
		##};
		#hyprsplit = {
		#	url = "github:shezdy/hyprsplit";
		#	inputs.hyprland.follows = "hyprland";
		#};
	};

	outputs = { self, nixpkgs, home-manager, hyprland, hyprsplit, ... }@inputs: 
		let 
			system = "x86_64-linux";
			pkgs = nixpkgs.legacyPackages.${system};
			#pkgs = import nixpkgs {
			#	inherit system;
			#	config.allowUnfree = true;
			#};
			lib = nixpkgs.lib;

		in {
			nixosConfigurations = {
				liz = nixpkgs.lib.nixosSystem {
					specialArgs = {inherit inputs; };
					modules = [ /etc/nixos/configuration.nix ];
				};
				#liz = lib.nixosSystem{
				#	inherit system;
				#	#modules = [ /etc/nixos/configuration.nix ];
				#	modules = [ ];
				#};
		};
		#packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
		#packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

	
		};
}
