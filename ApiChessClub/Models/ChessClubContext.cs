using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace ApiChessClub.Models
{
    public partial class ChessClubContext : DbContext
    {
        public ChessClubContext()
        {
        }

        public ChessClubContext(DbContextOptions<ChessClubContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Group> Groups { get; set; } = null!;
        public virtual DbSet<GroupType> GroupTypes { get; set; } = null!;
        public virtual DbSet<Payment> Payments { get; set; } = null!;
        public virtual DbSet<Picture> Pictures { get; set; } = null!;
        public virtual DbSet<Requisite> Requisites { get; set; } = null!;
        public virtual DbSet<Teacher> Teachers { get; set; } = null!;
        public virtual DbSet<TeacherCategory> TeacherCategories { get; set; } = null!;
        public virtual DbSet<Tournament> Tournaments { get; set; } = null!;
        public virtual DbSet<User> Users { get; set; } = null!;
        public virtual DbSet<UserTournament> UserTournaments { get; set; } = null!;

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
                optionsBuilder.UseSqlServer("Data Source=Lokatti\\SQLEXPRESS;Initial Catalog=ChessClub;Persist Security Info=True;User ID=sa;Password=123");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Group>(entity =>
            {
                entity.HasKey(e => e.GroupsId)
                    .HasName("PK__Groups__0F6940AD69CC6926");

                entity.Property(e => e.GroupsId).HasColumnName("GroupsID");

                entity.Property(e => e.GroupTypeId).HasColumnName("GroupTypeID");

                entity.Property(e => e.GroupsName).HasMaxLength(100);

                entity.Property(e => e.Price).HasColumnType("decimal(6, 2)");

                entity.Property(e => e.UsersId).HasColumnName("UsersID");
  });

            modelBuilder.Entity<GroupType>(entity =>
            {
                entity.ToTable("GroupType");

                entity.Property(e => e.GroupTypeId).HasColumnName("GroupTypeID");

                entity.Property(e => e.GroupTypeName).HasMaxLength(100);
            });

            modelBuilder.Entity<Payment>(entity =>
            {
                entity.ToTable("Payment");

                entity.Property(e => e.PaymentId).HasColumnName("PaymentID");

                entity.Property(e => e.Creating)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.Property(e => e.GroupsId).HasColumnName("GroupsID");

                entity.Property(e => e.UsersId).HasColumnName("UsersID");

              
            });

            modelBuilder.Entity<Picture>(entity =>
            {
                entity.ToTable("Picture");

                entity.Property(e => e.PictureId).HasColumnName("PictureID");

                entity.Property(e => e.UploadDate)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");
            });

            modelBuilder.Entity<Requisite>(entity =>
            {
                entity.HasKey(e => e.RequisitesId)
                    .HasName("PK__Requisit__58C05AC8B4959F35");

                entity.Property(e => e.RequisitesId).HasColumnName("RequisitesID");

                entity.Property(e => e.Balance).HasColumnType("decimal(6, 2)");

                entity.Property(e => e.CardNumber).HasMaxLength(100);
            });

            modelBuilder.Entity<Teacher>(entity =>
            {
                entity.HasKey(e => e.TeachersId)
                    .HasName("PK__Teachers__91FF204BAE1547CF");

                entity.Property(e => e.TeachersId).HasColumnName("TeachersID");

                entity.Property(e => e.FirstNameTeacher)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.GroupsId).HasColumnName("GroupsID");

                entity.Property(e => e.LastNameTeacher)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.MiddleNameTeacher)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.TeacherCategoryId).HasColumnName("TeacherCategoryID");

             });
            
            modelBuilder.Entity<TeacherCategory>(entity =>
            {
                entity.ToTable("TeacherCategory");

                entity.Property(e => e.TeacherCategoryId).HasColumnName("TeacherCategoryID");

                entity.Property(e => e.TeacherCategoryName).HasMaxLength(100);
            });

            modelBuilder.Entity<Tournament>(entity =>
            {
                entity.ToTable("Tournament");

                entity.Property(e => e.TournamentId).HasColumnName("TournamentID");

                entity.Property(e => e.TournamentName)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.UsersId).HasColumnName("UsersID");

             });

            modelBuilder.Entity<User>(entity =>
            {
                entity.HasKey(e => e.UsersId)
                    .HasName("PK__Users__A349B042E950B8A0");

                entity.Property(e => e.UsersId).HasColumnName("UsersID");

                entity.Property(e => e.Email)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.FcmToken).HasMaxLength(255);

                entity.Property(e => e.FirstName)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.LastName)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.MiddleName)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.Password)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.PictureId).HasColumnName("PictureID");

                entity.Property(e => e.RequisitesId).HasColumnName("RequisitesID");

                entity.Property(e => e.Role).HasMaxLength(30);

                entity.Property(e => e.Salt).HasMaxLength(255);

             });

            modelBuilder.Entity<UserTournament>(entity =>
            {
                entity.HasKey(e => e.UserTournamentsId)
                    .HasName("PK__UserTour__7A228FD88FF66A5D");

                entity.Property(e => e.UserTournamentsId).HasColumnName("UserTournamentsID");

                entity.Property(e => e.TournamentId).HasColumnName("TournamentID");

                entity.Property(e => e.UsersId).HasColumnName("UsersID");

           });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
