using System;
using System.Collections.Generic;

namespace ApiChessClub.Models
{
    public partial class Picture
    {
        public int PictureId { get; set; }
        public string PhotoData { get; set; } = null!;
        public DateTime UploadDate { get; set; }

    }
}
