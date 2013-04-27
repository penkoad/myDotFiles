""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Général
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Désactive la compatibilité avec VI (doit être la première ligne!)
set nocompatible

" Encodage en UTF-8
set encoding=utf-8

" Accélère le rendu graphique dans les terminaux véloces
set ttyfast

" Coloration syntaxique
syntax on

" Détection du type de fichier
filetype on

" Chargement des greffons en fonction du type
filetype plugin on

" Afficher une liste lors de complétion de commandes/fichiers
"set wildmenu                           "affiche le menu
"set wildmode=list:longest,list:full    "affiche toutes les possibilités

" Mesure de sécurité
set nomodeline

" Activer la souris (molette, sélection, etc.)
"set mouse=a

" Afficher des infos dans la barre de statut
set laststatus=2

" Afficher la position du curseur
set ruler

" Activer la numérotation des lignes
"set number

" Afficher partiellement la commande dans la ligne de statut
set showcmd

" Format de la ligne de statut
set statusline=%<%F\ %m%r%14.(%y[%{&encoding}]%)%=%-14.(%l,%v%)\ %P

" Afficher la correspondance des parenthèses
set showmatch

" Cacher les tampons quand ils sont abandonnés
set hidden

" Nombre de commandes maximale dans l'historique
set history=100

" Récupérer la position du curseur entre 2 ouvertures de fichiers
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif

" Afficher les espaces superflus et les tabulations
":hi ExtraWhitespace ctermbg=darkred
":match ExtraWhitespace /\s\+$\|\t/

" Suppression automatique des espaces superflu
autocmd BufWritePre * :%s/\s\+$//e

" Se place dans le répertoire du fichier éditer
autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

" Changement automatique de répertoire (exécution après compil)
set autochdir

" Permettre l'utilisation de la touche backspace dans tous les cas
set backspace=2

" Démarrer dans le répertoire Code
":chdir $HOME/code/
"set browsedir=current

" Affiche la limite de 80 caractères
" au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)

" Omni-completion
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Apparence
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Police
set gfn=Monospace\ 10
"set gfn=Inconsolata\ 10
"set gfn=Terminus\ 13

" Utiliser des couleurs correctes sur un fond sombre
set background=dark

" Le complément du précédent, devine tout seul la couleur du fond
set background&

" Afficher une ligne à la position du curseur
set cursorline
:hi CursorLine cterm=bold

" Thème de couleur pour Vim
"colorscheme devbox

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indentation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indentation en fonction du type de fichier
filetype indent on
" Indispensable pour ne pas tout casser avec ce qui va suivre
set preserveindent
" Activer l'indentation automatique
set autoindent
" Indentation plus intelligente
set smartindent
" Utiliser des tabulations de 4 caractères pour l'indentation
set noexpandtab
" Largeur de l'autoindentation
set shiftwidth=2
" Arrondit la valeur de l'indentation
set shiftround
" Largeur du caractère TAB
set tabstop=2
" Largeur de l'indentation de la touche TAB
set softtabstop=2
" Remplacer les tabulations par des espaces
set expandtab
" Pas d'espace pour les Makefile
autocmd FileType make setlocal noexpandtab
" Coller dans Vim sans tabulations incrémentées
set paste

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Correction orthographique
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" version Nemolivier
set nospell spelllang=fr
" automatique pour les fichiers .txt
augroup filetypedetect
au BufNewFile,BufRead *.txt setlocal spell spelllang=fr
augroup END

" F8 active/désactive la correction orthographique
:function! ToggleSpell()
  if &spell
     set nospell
  else
     set spell
  end
endfunction

"map a<F10> :echo "toto"
"#map <F8> :!ls<cr>

noremap <F8> :call ToggleSpell()<cr>
inoremap <F8> <Esc> :call ToggleSpell()<cr>a
vnoremap <F8> <Esc> :call ToggleSpell()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Recherches
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Utiliser la recherche incrémentielle
set incsearch

" Ne pas surligner les résultats de recherche
"set nohlsearch

" Surligner les résultats de recherche
set hlsearch

" Recherches:
"   - en minuscules = indépendante de la casse
"   - une majuscule = stricte
set smartcase

" Rechercher sans tenir compte de la casse
" (indépendant du précédent mais de priorité plus faible)
set ignorecase

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sauvegardes
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !filewritable($HOME."/.backup") " Si le repertoire n'existe pas
    call mkdir($HOME."/.backup", "p") " Creation du repertoire de sauvegarde
endif
set backupdir=$HOME/.backup " On definit le repertoire de sauvegarde
set backup " On active le comportement

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappage
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Descendre la ligne courante d'une ligne
"map <C-S-Down> dd p

" Remonter la ligne courante d'une ligne
"map <C-S-Up> dd kk 0 P

" Dupliquer la ligne courante via Ctrl-d (!!! désactive le scroll)
"map <C-d> yy p

" Ouverture de la liste des tags via la touche F2
"map <F2> :TlistToggle<cr>

" Ouverture de l'explorateur de fichiers avec la touche F3
"map <F3> :e .<cr>
map <F3> :browse e<cr>

" Gestion des onglets
map <F4> :tabnew<cr>
map <C-A-PageDown> :tabnext<cr>
map <C-A-PageUp> :tabprevious<cr>

" Exécuter le fichier
au BufEnter *.py map <F6> :!/usr/bin/python %<cr>
au BufEnter *.c map <F6> :!/usr/bin/gcc -o %:r % && ./%:r<cr>
au BufEnter *.vala map <F6> :!/usr/bin/vala %<cr>
au BufEnter *.gs map <F6> :!/usr/bin/vala %<cr>

" Exécuter le fichier actuel dans le navigateur via F7
map <F7> :!/usr/bin/x-www-browser %<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GUI
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Désactiver la barre de menu (m), d'outils (T) et de scroll (r+l)
set noequalalways " don't auto-resize when a window is closed
set guioptions-=T " disable the toolbar
set guioptions-=r " disable the right hand scrollbar
set guioptions-=R " disable the right hand scrollbar for vertically split window
set guioptions-=l " disable the left hand scrollbar
set guioptions-=L " disable the left hand scrollbar for vertically split window
set guioptions-=b " disable the bottom/horizontal scrollbar
set guioptions-=m " disable the menu

" Following Powerline feature does not work with my VIM
" Not compiled with the --with-features=big flag.
let g:Powerline_symbols = 'fancy'

" Pathogen
" https://github.com/tpope/vim-pathogen
call pathogen#infect()
syntax on
filetype plugin indent on

" Plugin vim-powerline
set laststatus=2 " Nombre de ligne de statut
set statusline=%F%m\ %r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v]\ [LENGTH=%P]
set t_Co=256

" Plugin Gundo
nnoremap <F5> :GundoToggle<CR>
