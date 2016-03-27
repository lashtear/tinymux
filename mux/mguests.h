/*! \file mguests.h
 * \brief Multiguest system.
 *
 * $Id$
 *
 */

#ifndef __MGUESTS_H
#define __MGUESTS_H

#include "copyright.h"
#include "interface.h"

#include <vector>

class CGuests
{
private:
//    static UTF8 name[50];
//    dbref *Guests;
    std::vector<dbref> Guests;
    void  SizeGuests(int);
    int   MakeGuestChar(void);     // Make the guest character
    void  DestroyGuestChar(dbref); // Destroy the guest character
    void  WipeAttrs(dbref guest);  // Wipe all the attrbutes
    void  AddToGuestChannel(dbref player);

public:
    CGuests(void) {};
    ~CGuests(void) {};

    bool  CheckGuest(dbref);
    void  ListAll(dbref);          // @list guests
    void  StartUp();
    const UTF8  *Create(DESC *d);
    void  CleanUp();
};

extern CGuests Guest;

#define GUEST_PASSWORD "Guest"

#endif // !__MGUESTS_H
