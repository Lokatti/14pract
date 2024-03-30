using System;
using System.Collections.Generic;

namespace ApiChessClub.Models
{
    public partial class Tournament
    {

        public int TournamentId { get; set; }
        public int UsersId { get; set; }
        public string TournamentName { get; set; } = null!;

        public virtual User Users { get; set; } = null!;
    }
}
