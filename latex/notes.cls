% Notes class
% Written by me
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{notes}[Notes for CS and math]
\LoadClass{article}

% Packages
    % Code highlighting
    \RequirePackage{listings}
    \RequirePackage{color}
    \RequirePackage{courier}

    % Math 
    \RequirePackage{amsmath}
    \RequirePackage{amssymb}
    \RequirePackage{amsfonts}
    \RequirePackage{mathtools}
    \RequirePackage[margin=1.5in]{geometry}

% Style
    \renewcommand\section{\@startsection {section}{1}{\z@}%
                                       {-3.5ex \@plus -1ex \@minus -.2ex}%
                                       {2.3ex \@plus.2ex}%
                                       {\normalfont\Large\scshape}}
    \renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                         {-3.25ex\@plus -1ex \@minus -.2ex}%
                                         {1.5ex \@plus .2ex}%
                                         {\normalfont\large\scshape}}
    \renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                         {-3.25ex\@plus -1ex \@minus -.2ex}%
                                         {1.5ex \@plus .2ex}%
                                         {\normalfont\normalsize\scshape}}

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
      numbers=none, % line numbers -- change to "left" if you want them
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
        tabsize=2,
        morekeywords={mutex, semaphore}
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
\newcommand{\Var}{\text{Var}}

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

% centered asterisks
\lst@CCPutMacro
  \lst@ProcessOther {"2A}{%
    \lst@ttfamily 
       {\raisebox{2pt}{*}}% used with ttfamily
       \textasteriskcentered}% used with other fonts
  \@empty\z@\@empty
