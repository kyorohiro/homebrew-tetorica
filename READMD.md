

# mDrop

```
brew tap kyorohiro/tetorica
brew install tetorica-mdrop
```

## command 

```
tetorica-mdrop /path/to/share
```

## service 

```
cp file.zip "$(brew --prefix)/var/tetorica-mdrop/share/"
brew services start tetorica-mdrop
```
