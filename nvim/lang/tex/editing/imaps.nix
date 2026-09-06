{
  plugins.vimtex.settings = {
    imaps_leader = "¡";
    imaps_list = [
      { lhs = "0"; rhs = "\\emptyset"; }
      { lhs = "2"; rhs = "\\sqrt"; }
      { lhs = "6"; rhs = "\\partial"; }
      { lhs = "8"; rhs = "\\infty"; }
      { lhs = "="; rhs = "\\equiv"; }
      { lhs = "\\"; rhs = "\\setminus"; }
      { lhs = "."; rhs = "\\cdot"; }
      { lhs = "*"; rhs = "\\times"; }
      { lhs = "<"; rhs = "\\langle"; }
      { lhs = ">"; rhs = "\\rangle"; }
      { lhs = "H"; rhs = "\\hbar"; }
      { lhs = "+"; rhs = "\\dagger"; }
      { lhs = "["; rhs = "\\subseteq"; }
      { lhs = "]"; rhs = "\\supseteq"; }
      { lhs = "("; rhs = "\\subset"; }
      { lhs = ")"; rhs = "\\supset"; }
      { lhs = "A"; rhs = "\\forall"; }
      { lhs = "B"; rhs = "\\boldsymbol"; }
      { lhs = "E"; rhs = "\\exists"; }
      { lhs = "N"; rhs = "\\nabla"; }
      { lhs = "a"; rhs = "\\alpha"; }
      { lhs = "b"; rhs = "\\beta"; }
      { lhs = "c"; rhs = "\\chi"; }
      { lhs = "d"; rhs = "\\delta"; }
      { lhs = "e"; rhs = "\\epsilon"; }
      { lhs = "f"; rhs = "\\phi"; }
      { lhs = "g"; rhs = "\\gamma"; }
      { lhs = "h"; rhs = "\\eta"; }
      { lhs = "i"; rhs = "\\iota"; }
      { lhs = "k"; rhs = "\\kappa"; }
      { lhs = "l"; rhs = "\\lambda"; }
      { lhs = "m"; rhs = "\\mu"; }
      { lhs = "n"; rhs = "\\nu"; }
      { lhs = "p"; rhs = "\\pi"; }
      { lhs = "q"; rhs = "\\theta"; }
      { lhs = "r"; rhs = "\\rho"; }
      { lhs = "s"; rhs = "\\sigma"; }
      { lhs = "t"; rhs = "\\tau"; }
      { lhs = "y"; rhs = "\\psi"; }
      { lhs = "u"; rhs = "\\upsilon"; }
      { lhs = "w"; rhs = "\\omega"; }
      { lhs = "z"; rhs = "\\zeta"; }
      { lhs = "x"; rhs = "\\xi"; }
      { lhs = "D"; rhs = "\\Delta"; }
      { lhs = "F"; rhs = "\\Phi"; }
      { lhs = "G"; rhs = "\\Gamma"; }
      { lhs = "L"; rhs = "\\Lambda"; }
      { lhs = "P"; rhs = "\\Pi"; }
      { lhs = "Q"; rhs = "\\Theta"; }
      { lhs = "S"; rhs = "\\Sigma"; }
      { lhs = "U"; rhs = "\\Upsilon"; }
      { lhs = "W"; rhs = "\\Omega"; }
      { lhs = "X"; rhs = "\\Xi"; }
      { lhs = "Y"; rhs = "\\Psi"; }
      { lhs = "ve"; rhs = "\\varepsilon"; }
      { lhs = "vf"; rhs = "\\varphi"; }
      { lhs = "vk"; rhs = "\\varkappa"; }
      { lhs = "vp"; rhs = "\\varpi"; }
      { lhs = "vq"; rhs = "\\vartheta"; }
      { lhs = "vr"; rhs = "\\varrho"; }
      { lhs = "/"; rhs = ''vimtex#imaps#style_math("slashed")''; expr = 1; leader = "#"; }
      { lhs = "b"; rhs = ''vimtex#imaps#style_math("mathbf")''; expr = 1; leader = "#"; }
      { lhs = "f"; rhs = ''vimtex#imaps#style_math("mathfrak")''; expr = 1; leader = "#"; }
      { lhs = "c"; rhs = ''vimtex#imaps#style_math("mathcal")''; expr = 1; leader = "#"; }
      { lhs = "-"; rhs = ''vimtex#imaps#style_math("overline")''; expr = 1; leader = "#"; }
      { lhs = "B"; rhs = ''vimtex#imaps#style_math("mathbb")''; expr = 1; leader = "#"; }
      { lhs = ":"; rhs = "\\colon"; wrapper = "vimtex#imaps#wrap_math"; }
      { lhs = "="; rhs = "\\leq"; leader = "<"; wrapper = "vimtex#imaps#wrap_math"; }
      { lhs = "="; rhs = "\\geq"; leader = ">"; wrapper = "vimtex#imaps#wrap_math"; }
      { lhs = "R"; rhs = "\\R"; wrapper = "vimtex#imaps#wrap_math"; }
      { lhs = "o"; rhs = "\\in"; wrapper = "vimtex#imaps#wrap_math"; }
    ];
  };
}
