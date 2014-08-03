/*! \file alloc.h
 * \brief External definitions for memory allocation subsystem.
 *
 * $Id$
 *
 */

#ifndef M_ALLOC_H
#define M_ALLOC_H

#define LBUF_SIZE   64000    // Large
#define GBUF_SIZE   2048    // Generic
#define MBUF_SIZE   1280     // Medium
#define PBUF_SIZE   128     // Pathname
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

#if defined(HAVE_LIBTCMALLOC)

// Okay, we have a high performance thread-safe allocator that can do
// heap checking and profiling.  Skip all this baroque pool chicanery.

#define pool_init(a,b) do {} while (0)

typedef enum {
    POOL_LBUF,
    POOL_SBUF,
    POOL_MBUF,
    POOL_BOOL,
    POOL_DESC,
    POOL_QENTRY,
    POOL_PCACHE,
    POOL_LBUFREF,
    POOL_REGREF,
    POOL_STRING,
    NUM_POOLS
} pool_idx_t;

#define pool_alloc(p,tag,file,line) abort()
/* extern UTF8 *pool_alloc(pool_idx_t p, */
/*                         __in const UTF8 *func, */
/*                         __in const UTF8 *file, */
/*                         int line); */

#define chfree(buf) do {                        \
        mux_assert(buf != NULL);                \
        free(buf); } while (0)
#define pool_free(p,buf,file,line) chfree(buf)

// Used only in timer.cpp
#define pool_reset() do {} while (0)


// Used directly only in db.cpp
#define pool_alloc_lbuf(tag,file,line) alloc_lbuf(tag)

// These are only used in command.cpp
extern void list_bufstats(dbref);
extern void list_buftrace(dbref);

#define alloc_sbuf(s)    (UTF8 *) calloc(1, SBUF_SIZE)
#define alloc_mbuf(s)    (UTF8 *) calloc(1, MBUF_SIZE)
#define alloc_lbuf(s)    (UTF8 *) calloc(1, LBUF_SIZE)
#define alloc_bool(s)    (struct boolexp *) calloc(1, sizeof(struct boolexp))
#define alloc_qentry(s)  (BQUE *) calloc(1, sizeof(BQUE))
#define alloc_pcache(s)  (PCACHE *) calloc(1, sizeof(PCACHE))
#define alloc_lbufref(s) (lbuf_ref *) calloc(1, sizeof(lbuf_ref))
#define alloc_regref(s)  (reg_ref *) calloc(1, sizeof(reg_ref))
#define alloc_string(s)  (mux_string *) calloc(1, sizeof(mux_string))
#define alloc_desc(s)    (DESC *) calloc(1, sizeof(DESC))
#define free_sbuf(b)     chfree(b)
#define free_mbuf(b)     chfree(b)
#define free_lbuf(b)     chfree(b)
#define free_bool(b)     chfree(b)
#define free_qentry(b)   chfree(b)
#define free_pcache(b)   chfree(b)
#define free_lbufref(b)  chfree(b)
#define free_regref(b)   chfree(b)
#define free_string(b)   chfree(b)
#define free_desc(b)     chfree(b)

#else

// Sometimes, we might need the chicanery.

#define POOL_LBUF    0
#define POOL_SBUF    1
#define POOL_MBUF    2
#define POOL_BOOL    3
#define POOL_DESC    4
#define POOL_QENTRY  5
#define POOL_PCACHE  6
#define POOL_LBUFREF 7
#define POOL_REGREF  8
#define POOL_STRING  9
#define NUM_POOLS    10

extern void pool_init(int, int);
extern UTF8 *pool_alloc(int, __in const UTF8 *, __in const UTF8 *, int);
extern UTF8 *pool_alloc_lbuf(__in const UTF8 *, __in const UTF8 *, int);
extern void pool_free(int, __in UTF8 *, __in const UTF8 *, int);
extern void pool_free_lbuf(__in_ecount(LBUF_SIZE) UTF8 *, __in const UTF8 *, int);
extern void list_bufstats(dbref);
extern void list_buftrace(dbref);
extern void pool_reset(void);

#define alloc_desc(s) (DESC *)pool_alloc(POOL_DESC, (UTF8 *)s, (UTF8 *)__FILE__, __LINE__)
#define free_desc(b) pool_free(POOL_DESC,(UTF8 *)(b), (UTF8 *)__FILE__, __LINE__)
#define alloc_lbuf(s)    pool_alloc_lbuf((UTF8 *)s, (UTF8 *)__FILE__, __LINE__)
#define free_lbuf(b)     pool_free_lbuf((UTF8 *)(b), (UTF8 *)__FILE__, __LINE__)
#define alloc_mbuf(s)    pool_alloc(POOL_MBUF, (UTF8 *)s, (UTF8 *)__FILE__, __LINE__)
#define free_mbuf(b)     pool_free(POOL_MBUF,(UTF8 *)(b), (UTF8 *)__FILE__, __LINE__)
#define alloc_sbuf(s)    pool_alloc(POOL_SBUF, (UTF8 *)s, (UTF8 *)__FILE__, __LINE__)
#define free_sbuf(b)     pool_free(POOL_SBUF,(UTF8 *)(b), (UTF8 *)__FILE__, __LINE__)
#define alloc_bool(s)    (struct boolexp *)pool_alloc(POOL_BOOL, (UTF8 *)s, (UTF8 *)__FILE__, __LINE__)
#define free_bool(b)     pool_free(POOL_BOOL,(UTF8 *)(b), (UTF8 *)__FILE__, __LINE__)
#define alloc_qentry(s)  (BQUE *)pool_alloc(POOL_QENTRY, (UTF8 *)s, (UTF8 *)__FILE__, __LINE__)
#define free_qentry(b)   pool_free(POOL_QENTRY,(UTF8 *)(b), (UTF8 *)__FILE__, __LINE__)
#define alloc_pcache(s)  (PCACHE *)pool_alloc(POOL_PCACHE, (UTF8 *)s, (UTF8 *)__FILE__, __LINE__)
#define free_pcache(b)   pool_free(POOL_PCACHE,(UTF8 *)(b), (UTF8 *)__FILE__, __LINE__)
#define alloc_lbufref(s) (lbuf_ref *)pool_alloc(POOL_LBUFREF, (UTF8 *)s, (UTF8 *)__FILE__, __LINE__)
#define free_lbufref(b)  pool_free(POOL_LBUFREF,(UTF8 *)(b), (UTF8 *)__FILE__, __LINE__)
#define alloc_regref(s)  (reg_ref *)pool_alloc(POOL_REGREF, (UTF8 *)s, (UTF8 *)__FILE__, __LINE__)
#define free_regref(b)   pool_free(POOL_REGREF,(UTF8 *)(b), (UTF8 *)__FILE__, __LINE__)
#define alloc_string(s)  (mux_string *)pool_alloc(POOL_STRING, T(s), (UTF8 *)__FILE__, __LINE__)
#define free_string(b)   pool_free(POOL_STRING,(UTF8 *)(b), (UTF8 *)__FILE__, __LINE__)

#endif

#define safe_copy_chr_ascii(src, buff, bufp, nSizeOfBuffer) \
{ \
    if ((size_t)(*bufp - buff) < nSizeOfBuffer) \
    { \
        **bufp = src; \
        (*bufp)++; \
    } \
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
