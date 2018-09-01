/*! \file alloc.h
 * \brief External definitions for memory allocation subsystem.
 *
 * $Id$
 *
 */

#ifndef M_ALLOC_H
#define M_ALLOC_H

#define LBUF_SIZE   65536    // Large
#define MBUF_SIZE   1280     // Medium
#define SBUF_SIZE   64      // Small

//! \struct lbuf_ref
// Tracks references to an lbuf. See LBUF_SIZE.
// Used only in eval.cpp
struct lbuf_ref
{
    int      refcount;
    UTF8    *lbuf_ptr;
};

//! \struct reg_ref
// Tracks references to a register.
// Used only in eval.cpp
struct reg_ref
{
    int      refcount;
    lbuf_ref *lbuf;
    size_t   reg_len;
    UTF8    *reg_ptr;
};

// Okay, we have a high performance thread-safe allocator that can do
// heap checking and profiling.  We link against it if it exists, and
// if not, we don't need to worry about it. Skip all this baroque pool
// chicanery.

/** Raise hell if we're freeing a NULL. */
inline void
chfree (void *m)
{
    mux_assert (m != NULL);
    free (m);
}

/** Provide a faster alternative to calloc that zeroes only the start */
inline void *
allocz (ssize_t s)
{
    void *m;

    /* allocate at least one word worth */
    mux_assert (s > 0);
    if (s < sizeof(long int)) s = sizeof(long int);

    /* allocate no more than 1GB at a time ever */
    mux_assert (s < (1<<30)-1);

    /* howl if we didn't get it */
    m = malloc (s);
    ISOUTOFMEMORY(m);

    /* zero the first word */
    *((long int*) m) = 0;
    return m;
}

#define alloc_sbuf(s)    (UTF8 *) allocz (SBUF_SIZE)
#define alloc_mbuf(s)    (UTF8 *) allocz (MBUF_SIZE)
#define alloc_lbuf(s)    (UTF8 *) allocz (LBUF_SIZE)
#define alloc_bool(s)    (struct boolexp *) calloc(1, sizeof(struct boolexp))
#define alloc_qentry(s)  (BQUE *) calloc(1, sizeof(BQUE))
#define alloc_pcache(s)  (PCACHE *) calloc(1, sizeof(PCACHE))
#define alloc_lbufref(s) (lbuf_ref *) calloc(1, sizeof(lbuf_ref))
#define alloc_regref(s)  (reg_ref *) calloc(1, sizeof(reg_ref))
#define alloc_desc(s)    (DESC *) calloc(1, sizeof(DESC))
#define free_sbuf(b)     chfree(b)
#define free_mbuf(b)     chfree(b)
#define free_lbuf(b)     chfree(b)
#define free_bool(b)     chfree(b)
#define free_qentry(b)   chfree(b)
#define free_pcache(b)   chfree(b)
#define free_lbufref(b)  chfree(b)
#define free_regref(b)   chfree(b)
#define free_desc(b)     chfree(b)

inline void
safe_copy_chr_ascii (const char src,
		     UTF8 *buff,
		     UTF8 **bufp,
		     size_t bufsize)
{
    if ((size_t)(*bufp - buff) < bufsize) {
	**bufp = src;
	(*bufp)++;
    }
}

#define safe_str(s,b,p)           safe_copy_str_lbuf(s,b,p)
#define safe_bool(c,b,p)          safe_chr(((c) ? '1' : '0'),b,p)
#define safe_sb_str(s,b,p)        safe_copy_str(s,b,p,(SBUF_SIZE-1))
#define safe_mb_str(s,b,p)        safe_copy_str(s,b,p,(MBUF_SIZE-1))

#define safe_chr_ascii(c,b,p)     safe_copy_chr_ascii((UTF8)(c),b,p,(LBUF_SIZE-1))
#define safe_sb_chr_ascii(c,b,p)  safe_copy_chr_ascii(c,b,p,(SBUF_SIZE-1))
#define safe_mb_chr_ascii(c,b,p)  safe_copy_chr_ascii(c,b,p,(MBUF_SIZE-1))

// Slowly transition from safe_chr to safe_chr_ascii and safe_chr_utf8,
// safe_sb_chr to safe_sb_chr_ascii,and safe_mb_chr to safe_mb_chr_ascii.
//
#define safe_sb_chr safe_sb_chr_ascii
#define safe_mb_chr safe_mb_chr_ascii
#define safe_chr safe_chr_ascii

#endif // M_ALLOC_H
