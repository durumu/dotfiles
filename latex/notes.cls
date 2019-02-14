% Notes class
% Written by me
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{notes}[Notes for CS and math]
\LoadClass{article}

% Packages
    % Code highlighting
    \RequirePackage{listings}
    \RequirePackage{color}

    % Math 
    \RequirePackage{amsmath}
    \RequirePackage{amssymb}
    \RequirePackage{amsfonts}
    \RequirePackage{mathtools}

% Listings
    \definecolor{dkgreen}{rgb}{0,0.6,0}
    \definecolor{gray}{rgb}{0.5,0.5,0.5}
    \definecolor{mauve}{rgb}{0.58,0,0.82}

    \lstloadlanguages{[ISO]C++, Python}

    \lstset{frame=tb,
      language=[ISO]C++,
      aboveskip=2mm,
      belowskip=2mm,
      showstringspaces=false,
      columns=flexible,
      basicstyle={\small\ttfamily},
      numbers=none,
      numberstyle=\tiny\color{gray},
      keywordstyle=\bfseries\color{blue},
      commentstyle=\itshape\color{dkgreen},
      stringstyle=\color{mauve},
      breaklines=true,
      breakatwhitespace=true,
      tabsize=2
    }

    % C++ environment
    \lstnewenvironment{cpp} {
      \lstset{
        language=[ISO]C++,
        tabsize=2
      }
    } {}

    % Python environment
    \lstnewenvironment{py} {
      \lstset{
        language=Python,
        tabsize=4
        }
    } {}

% Inline monospaced text
\newcommand{\code}[1]{\texttt{#1}}

% Large, isolated pieces of code from a file, in C++/Python
\newcommand{\cppf}[1]{\lstinputlisting{#1.cpp}}
\newcommand{\pyf}[1]{\lstinputlisting[language=Python]{#1.py}}

% Math-mode symbols
\newcommand{\Z}{\mathbb{Z}}
\newcommand{\R}{\mathbb{R}}
\newcommand{\Q}{\mathbb{Q}}
\newcommand{\C}{\mathbb{C}}
\newcommand{\F}{\mathbb{F}}

% type \ceil{x} or \floor{y}
\DeclarePairedDelimiter\ceil{\lceil}{\rceil}
\DeclarePairedDelimiter\floor{\lfloor}{\rfloor}

% black magic
\newcommand{\splitatcommas}[1]{%
  \begingroup
  \begingroup\lccode`~=`, \lowercase{\endgroup
    \edef~{\mathchar\the\mathcode`, \penalty0 \noexpand\hspace{0pt plus 1em}}%
  }\mathcode`,="8000 #1%
  \endgroup
}
