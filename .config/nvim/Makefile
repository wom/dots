install:
	git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim || true
	nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
clean:
	rm -rf ~/.cache/nvim
	rm -rf ~/.local/share/nvim
