using System;
using System.Collections.Generic;

namespace ApiChessClub.Models
{
    public partial class Requisite
    {
        public int RequisitesId { get; set; }
        public string CardNumber { get; set; } = null!;
        public decimal Balance { get; set; }

    }
}
